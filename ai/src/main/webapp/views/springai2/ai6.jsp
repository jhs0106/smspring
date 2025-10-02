<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    const CONFIG = {
        contextPath: '<c:url value="/"/>',
        imagePath: '<c:url value="/image/"/>',
        api: {
            chat: '<c:url value="/ai2/shop-chat"/>'
        },
        style: {
            avatarSize: '60px',
            cardImageHeight: '100px',
            menuImageSize: '50px',
            userBg: '#e3f2fd',
            aiBg: '#fff3e0'
        }
    };

    let ai6 = {
        init: function () {
            this.bindEvents();
            $('#spinner').css('visibility', 'hidden');
        },

        bindEvents: function () {
            $('#send').click(() => this.send());
            $('#question').keypress((e) => {
                if (e.which === 13 && !e.shiftKey) {
                    this.send();
                    return false;
                }
            });
        },

        send: async function () {
            // ... send 메소드 내용은 이전과 동일 ...
            const question = $('#question').val().trim();
            if (!question) {
                alert("질문을 입력해주세요.");
                return;
            }

            this.showSpinner(true);
            this.displayUserMessage(question);
            $('#question').val('');

            const uuid = this.createAssistantUI();

            try {
                const params = new URLSearchParams({request: question});
                const response = await fetch(CONFIG.api.chat, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params
                });

                if (!response.ok) throw new Error('HTTP ' + response.status);

                const data = await response.json();
                this.renderResponse(uuid, data);
            } catch (error) {
                this.handleError(uuid, error);
            } finally {
                this.showSpinner(false);
            }
        },

        renderResponse: function (uuid, data) {
            let html = this.buildMessage(data.message);

            if (data.status === 'SHOW_MENU' && data.orderData?.orderItems?.length > 0) {
                html += this.buildMenuList(data.orderData.orderItems);
            }
            else {
                if (data.unavailableItems?.length > 0) {
                    html += this.buildAlert('warning', '주문 불가', data.unavailableItems.join(', '));
                }
                if (data.clarificationQuestions?.length > 0) {
                    html += this.buildAlert('info', '질문', data.clarificationQuestions.join('<br>'));
                }
                const items = data.orderData?.orderItems;
                if (items?.length > 0) {
                    html += this.buildOrderCards(items);
                }
            }

            $('#' + uuid).html(html);
        },

        buildMessage: function (message) {
            return '<p>' + this.escapeHtml(message || '응답 메시지가 없습니다.') + '</p>';
        },

        buildMenuList: function (items) {
            const groupedByCategory = items.reduce((acc, item) => {
                const category = item.categoryName || '기타';
                if (!acc[category]) {
                    acc[category] = [];
                }
                acc[category].push(item);
                return acc;
            }, {});

            const categoryOrder = ['주메뉴', '사이드메뉴', '음료'];

            let menuHtml = '<div class="mt-3 p-3 border-top bg-light"><h6>📋 메뉴판</h6>';

            // 3. 정의된 순서대로 카테고리를 반복하며 HTML을 생성합니다.
            categoryOrder.forEach(categoryName => {
                const categoryItems = groupedByCategory[categoryName];
                if (categoryItems && categoryItems.length > 0) {
                    menuHtml += '<h6 class="mt-3">[' + this.escapeHtml(categoryName) + ']</h6>';
                    menuHtml += '<ul class="list-unstyled">';
                    categoryItems.forEach(item => {
                        menuHtml +=
                            '<li class="media align-items-center mb-2">' +
                            '  <img src="' + CONFIG.imagePath + item.imageName + '" class="mr-3" style="width: ' + CONFIG.style.menuImageSize + ';">' +
                            '  <div class="media-body">' +
                            '    <p class="mt-0 mb-1"><strong>' + this.escapeHtml(item.menuName) + '</strong></p>' +
                            '    <p>' + item.price.toLocaleString() + '원</p>' +
                            '  </div>' +
                            '</li>';
                    });
                    menuHtml += '</ul>';
                }
            });

            menuHtml += '</div>';
            return menuHtml;
        },

        buildAlert: function (type, title, content) {
            return '<div class="alert alert-' + type + ' mt-2"><strong>' + title + ':</strong> ' + content + '</div>';
        },

        buildOrderCards: function (items) {
            let html = '';
            let total = 0;
            let summaryItems = [];

            items.forEach(item => {
                const itemTotal = item.price * item.quantity;
                total += itemTotal;
                html += this.buildOrderCard(item, itemTotal);
                summaryItems.push(item.menuName + ' (' + item.quantity + '개) - ' + itemTotal.toLocaleString() + '원');
            });

            html += this.buildOrderSummary(summaryItems, total);
            return html;
        },

        buildOrderCard: function (item, itemTotal) {
            return (
                '<div class="card mb-2 shadow-sm">' +
                '  <div class="row no-gutters align-items-center">' +
                '    <div class="col-md-3 text-center">' +
                '      <img src="' + CONFIG.imagePath + item.imageName + '" class="img-fluid p-2" style="max-height:' + CONFIG.style.cardImageHeight + ';">' +
                '    </div>' +
                '    <div class="col-md-9">' +
                '      <div class="card-body py-2">' +
                '        <h5 class="card-title mb-1">' + item.menuName + '</h5>' +
                '        <p class="card-text mb-0">수량: ' + item.quantity + '개</p>' +
                '        <p class="card-text mb-0">단가: ' + item.price.toLocaleString() + '원</p>' +
                '        <p class="card-text font-weight-bold">합계: ' + itemTotal.toLocaleString() + '원</p>' +
                '      </div>' +
                '    </div>' +
                '  </div>' +
                '</div>'
            );
        },

        buildOrderSummary: function (items, total) {
            const itemList = items.map(item => '<li>' + item + '</li>').join('');
            return (
                '<div class="mt-3 p-3 border-top bg-light">' +
                '  <h6>주문서</h6>' +
                '  <ul class="list-unstyled">' + itemList + '</ul>' +
                '  <hr>' +
                '  <h5>총 주문 금액: ' + total.toLocaleString() + '원</h5>' +
                '</div>'
            );
        },
        displayUserMessage: function (msg) {
            const html = this.buildMediaBox(
                CONFIG.imagePath + "user.png",
                "고객",
                '<p>' + this.escapeHtml(msg) + '</p>',
                CONFIG.style.userBg,
                "left"
            );
            $("#result").prepend(html);
        },

        createAssistantUI: function () {
            const uuid = "id-" + crypto.randomUUID();
            const html = this.buildMediaBox(
                CONFIG.imagePath + "assistant.png",
                "주문 도우미",
                '<div id="' + uuid + '"><span class="spinner-border spinner-border-sm"></span> 생각 중...</div>',
                CONFIG.style.aiBg,
                "right"
            );
            $("#result").prepend(html);
            return uuid;
        },

        buildMediaBox: function (imgSrc, title, content, bgColor, imgPosition) {
            const imgHtml = '<img src="' + imgSrc + '" alt="' + title + '" class="' + (imgPosition === 'left' ? 'mr-3' : 'ml-3') + ' mt-3 rounded-circle" style="width:' + CONFIG.style.avatarSize + ';">';
            const bodyHtml = '<div class="media-body">' +
                '<p class="mb-1"><strong>' + title + '</strong></p>' +
                '<div>' + content + '</div>' +
                '</div>';
            const contentOrder = imgPosition === 'left' ? imgHtml + bodyHtml : bodyHtml + imgHtml;
            return '<div class="media border p-3 mb-2" style="background-color:' + bgColor + ';">' + contentOrder + '</div>';
        },

        escapeHtml: function (text) {
            return text.replace(/</g, "&lt;").replace(/>/g, "&gt;");
        },

        showSpinner: function (show) {
            $('#spinner').css('visibility', show ? 'visible' : 'hidden');
        },

        handleError: function (uuid, error) {
            console.error("오류:", error);
            $('#' + uuid).html(this.buildAlert('danger', '오류', '처리 중 문제가 발생했습니다.'));
        }
    };

    $(() => {
        ai6.init();
    });
</script>

<div class="col-sm-10">
    <h2>SpringAI Shop</h2>
    <div class="row mb-2">
        <div class="col-sm-8">
            <textarea id="question" class="form-control" rows="2"
                      placeholder="메뉴를 주문하거나 '메뉴판 보여줘'를 입력하세요"></textarea>
        </div>
        <div class="col-sm-2">
            <button type="button" class="btn btn-primary btn-block" id="send">전송</button>
        </div>
        <div class="col-sm-2">
            <button class="btn btn-secondary btn-block" disabled>
                <span class="spinner-border spinner-border-sm" id="spinner"></span>
                로딩..
            </button>
        </div>
    </div>

    <div id="result" class="container p-3 my-3 border"
         style="overflow-y:auto; height:500px; background-color:#fafafa;"></div>
</div>

