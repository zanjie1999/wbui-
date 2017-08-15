<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script>
        $(function(){
            //页数
            page = 0;
            //显示字数
            maxParagraphLength = 80;
            //是否刷新
            reload = false;
            //加载中
            loading = false;

            $('.weui_panel').dropload({
                scrollArea : window,
                autoLoad : true,//自动加载
                domDown : {//上拉
                    domClass   : 'dropload-down',
                    domRefresh : '<div class="dropload-refresh f15 "><i class="icon icon-20"></i>上拉加载更多</div>',
                    domLoad    : '<div class="dropload-load f15"><span class="weui-loading"></span>正在加载中...</div>',
                    domNoData  : '<div class="dropload-noData">没有更多数据了</div>'
                },
                domUp : {//下拉
                    domClass   : 'dropload-up',
                    domRefresh : '<div class="dropload-refresh"><i class="icon icon-114"></i>下拉加载更多</div>',
                    domUpdate  : '<div class="dropload-load f15"><i class="icon icon-20"></i>释放更新...</div>',
                    domLoad    : '<div class="dropload-load f15"><span class="weui-loading"></span>正在加载中...</div>'
                },
                loadUpFn : function(me){//刷新
                    console.log('loading:'+loading);
                    if(!loading){
                        reload = true;
                        loading = true;

//                        $('.weui_panel_bd').html('');
//                        $('.dropload-down').html('');
//                        $('.dropload-refresh').hide();
//                        $('.dropload-noData').html('');

                        page=1;
                        load(me);

//                        // 解锁
//                        me.noData(false);
                    }
                },
                loadDownFn : function(me){//加载更多
                    console.log('loading:'+loading);
                    if(!loading){
                        reload = false;
                        loading = true;

                        page++;
                        load(me);
                    }
                }
            });

            function load(thisMe) {
            <%--window.history.pushState(null, document.title, window.location.href);--%>
                var result = '';
                var url = '<%=basePath%>/friendshipMessage/friendshipMessageAction!getFriendshipMessageList.action?mPage='+page+'&type=${type}&isall=${isall}';
                console.log('type=${type} isall=${isall}');
                //微信api设置
            <%--var access_token = '';--%>
                <%--var lang = 'zh_CN';--%>
                var headimgurl = '<%=basePath%>yiqiweixin/images/RainbowDash.gif';
                var nickname = 'RainbowDash';
                $.ajax({
                    type: 'POST',
                    url: url,
                    data:{
                        'page':page,
                        'type':'${type}',
                        'isall':'${isall}'
                    },
                    dataType: 'json',
                    success: function(data){
                        if(!data.success){
                            alert(data.msg);
                        }
                        var arrLen = data.length;
                        console.log('当前页码:'+data.page);
                        console.log('长度:'+arrLen);
                        console.log(data.list);
                        if(arrLen > 0){

                            for(var i=0; i<arrLen; i++){
                                var likeNum = '0';
                                var discussNum = '0';

                                var postText = data.list[i].content;
                            <%--postText+='<br>彩虹小馬（My Little Pony）是美國遊戲與玩具製造公司孩之寶於1983年所推出的女孩玩具產品系列。為一種擁有各種色彩、可在上面塗鴉及梳理鬃毛的馬型玩具，最初產品的形象是由Bonnie Zacherle所設計的，目前已發展至第四代。第一代的系列動畫片則於1986年開始播映。2010年，由蘿倫·浮士德擔任製作人的第四代動畫片《彩虹小馬：友情就是魔法》播出後，意外吸引了許廣大年長的觀眾，其中大多數是男性青少年與成人，打破了本系列收視族群一向為女性幼童的刻板印象。</p>';--%>

                                var paragraphExtenderShow = false;

                                if(typeof(data.list[i].customer.customer_name) != "undefined"){
                                    nickname = data.list[i].customer.customer_name;
                                }
                                if(typeof(data.list[i].customer.portrait) != "undefined"){
                                    headimgurl = data.list[i].customer.portrait;
                                }


                                result+='<!-- 普通的post id:'+data.list[i].id+' -->'
                                    +'<div class="weui_cell moments__post">';

                            <%--var url = 'https://api.weixin.qq.com/cgi-bin/user/info?access_token='+access_token+'&openid='+data.list[i].openid+'&lang='+lang--%>
                                    <%--$.ajax({--%>
                                        <%--type: 'GET',--%>
                                <%--url: url,--%>
                                <%--async:false,--%>
                                <%--dataType: 'json',--%>
                                <%--success: function(data){--%>
                                <%--if(data.headimgurl != null){--%>
                                <%--headimgurl = data.headimgurl;--%>
                                <%--}--%>
                                <%--if(data.nickname != null){--%>
                                <%--nickname = data.nickname;--%>
                                <%--}--%>
                                result+='      <!-- 头像 -->'
                                    +'      <div class="weui_cell_hd">'
                                    +'        <img src="'+headimgurl+'">'
                                    +'      </div>'
                                    +'      <div class="weui_cell_bd">'
                                    +'        <!-- 人名链接 -->'
                                    +'        <a class="title">'
                                    +'            <span>'+nickname+'</span>'
                                    +'        </a>';
                                <%--}--%>
                                <%--});--%>

                                result+='        <!-- post内容 -->';

                                if(postText.length > maxParagraphLength){
                                    paragraphExtenderShow = true;
                                    result +='<p style="display: none;">'+postText+'</p>'
                                        +'        <p id="paragraph" class="paragraph">'
                                        + postText.substring(0, maxParagraphLength) + '...';
                                }else{
                                    result +='<p id="paragraph" class="paragraph">'
                                        +postText;
                                }

                                result+='       </p>'
                                    +'        <!-- 伸张链接 -->';

                                if(paragraphExtenderShow){
                                    result += '<a id="paragraphExtender" class="paragraphExtender">显示全文</a>';
                                }else{
                                    result += '<a id="paragraphExtender" class="paragraphExtender" style="display: none;">显示全文</a>';
                                }

                                result+='        <!-- 相册 -->'
                                    +'        <div class="thumbnails">';

                            <%--var url = '<%=basePath%>/friendshipMessage/friendshipMessageAction!getFriendshipMessagePhotoLikeDiscuss.action?id='+data.list[i].id;--%>
                                <%--$.ajax({--%>
                                    <%--type: 'GET',--%>
                                <%--url: url,--%>
                                <%--async:false,--%>
                                <%--dataType: 'json',--%>
                                <%--success: function(data){--%>
                                    var photo = data.list[i].uploadFiles;
                                    console.log("当前id:"+data.list[i].id);
                                    for(var p=0;p < arrLen;p++){
                                        if(photo != null && photo[p] != null){
                                            console.log("图片路径:"+photo[p].file_path);
                                            result+='<div class="thumbnail">'
                                                +'<img src="'+photo[p].file_path+'"  style="height:100%;object-fit: cover;"/>'
                                                +'</div>'
                                                +'<div class="weui_msg_img hide" id="weui_msg_img">'
                                                +'    <div class="weui_msg_com">'
                                                +'        <div class="weui_msg_src">'
                                                +'            <img src="'+photo[p].file_path+'">'
                                                +'        </div>'
                                                +'    </div>'
                                                +'</div>';

                                        <%--+'<img src="<%=basePath%>yiqiweixin/images/xyy.jpg" />'--%>
                                            <%--+'</div>'--%>
                                            <%--+'<div class="weui_msg_img hide" id="weui_msg_img">'--%>
                                            <%--+'    <div class="weui_msg_com">'--%>
                                            <%--+'        <div class="weui_msg_src">'--%>
                                            <%--+'            <img src="<%=basePath%>yiqiweixin/images/xyy.jpg">'--%>
                                            <%--+'        </div>'--%>
                                            <%--+'    </div>'--%>
                                            <%--+'</div>';--%>

                                            <%--console.log(result);--%>
                                        }
                                    }
                                    if(typeof(data.list[i].num_like) != "undefined"){
                                        likeNum = data.list[i].num_like;
                                    }
                                    if(typeof(data.list[i].num_discuss) != "undefined"){
                                        discussNum = data.list[i].num_discuss;
                                    }
                                <%--}--%>
                                <%--});--%>

                                <%--for(var p=1;p<=3;p++){--%>
                                <%--if(data.list[i].file_path != null){--%>
                                <%--result+='<div class="thumbnail">'--%>
                                    <%--+'<img src="'+data.list[i].file_path[p]+'" />'--%>
                                    <%--+'</div>'--%>
                                    <%--}--%>
                                <%--}--%>

                                result+='        </div> '
                                    +'        <!-- 资料条 -->'
                                    +'        <div class="toolbar" style="color:#696969">'
                                    +'            路线:'+data.list[i].happend_route+'&nbsp;&nbsp;'
                                    +'            车牌:'+data.list[i].car_no+'&nbsp;&nbsp;'
                                    +'        </div>'
                                    +'<div class="toolbar"  style="color:#5d6b85">'+data.list[i].create_time+'</div>'
                                    +'<div class="toolbar">'
                                    +'        <p class="timestamp">'
                                    +'            <p style="display: none;">'+data.list[i].id+'</p>'
                                    +'            <p style="display: none;">'+likeNum+'</p>'
                                    +'            <a class="btn ico_dz">点赞('+likeNum+')&nbsp;&nbsp;</a>'
                                    +'            <a class="btn ico_pl" href = "<%=basePath%>/activemessage/activeMessageAction!findDiscussList.action?type=2&message_id='+data.list[i].id+'" >评论('+discussNum+')&nbsp;&nbsp;</a>'
                                    +'        </p>'
                                    +'</div>'
                                    +'</div>'
                                    +'<!-- 结束 post -->'
                                    +'</div>';






                            }
                            // 如果没有数据
                        }else{
//                            // 锁定
//                            thisMe.lock();
                            // 无数据
                            thisMe.noData();
                        }

                        // 为了测试，延迟1秒加载
//                        setTimeout(function(){

                        //如果是刷新,先清空
                        if(reload){
                            $('.weui_panel_bd').html('');
                        }

                        $('.weui_panel_bd').append(result);

                        var lazyloadImg = new LazyloadImg({
                            el: '.weui-updown [data-img]', //匹配元素
                            top: 50, //元素在顶部伸出长度触发加载机制
                            right: 50, //元素在右边伸出长度触发加载机制
                            bottom: 50, //元素在底部伸出长度触发加载机制
                            left: 50, //元素在左边伸出长度触发加载机制
                            qriginal: false, // true，自动将图片剪切成默认图片的宽高；false显示图片真实宽高
                            load: function(el) {
                                el.style.cssText += '-webkit-animation: fadeIn 01s ease 0.2s 1 both;animation: fadeIn 1s ease 0.2s 1 both;';
                            },
                            error: function(el) {

                            }
                        });
                        //
                        // 每次数据加载完，必须重置
                        thisMe.resetload();
//                        },1000);

                        //检查是否刷新进行解锁
                        if (arrLen >= 10) {
                            if(reload) {
                                // 解锁
//                                thisMe.unlock();
                                // 还有数据
                                thisMe.noData(false);
                            }
                        } else {
//                                // 锁定
//                                thisMe.lock();
                            // 无数据
                            thisMe.noData();

                            //避开bug
                            $(".f15").parent().append('<div class="dropload-noData">没有更多数据了</div>');
                            $(".f15").remove();

                        }

                        loading = false;
                    },
                    error: function(xhr, type){
                        $.toast("数据加载失败", "cancel");
                        //alert('数据加载失败');
                        // 即使加载出错，也得重置
                        thisMe.resetload();
                        loading = false;
                    }
                });

            }

            });
    </script>
</head>
<body>
    <div class="weui_panel weui_panel_access">

    <div class="weui_panel_bd"></div>
    </div>
</body>
</html>