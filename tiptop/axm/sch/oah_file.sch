/*
================================================================================
檔案代號:oah_file
檔案名稱:价格条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oah_file
(
oah01       varchar2(6) NOT NULL,    /*价格条件编号                           */
                                     /*價格條件編號   Ex:FOB  CIF C與F CIF與C5*/
oah02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
oah03       varchar2(2),             /*报价取价或订单取价方式                 */
                                     /*報價取價或訂單取價方式                 */
                                     /* 0.人工輸入                            */
                                     /* 1.取產品檔內的訂價                    */
                                     /* 2.取產品價格檔內的訂價                */
                                     /* 3.取產品客戶檔內的上次訂單單價        */
                                     /* 4.依價格表取價  #No:A036              */
oah04       varchar2(1) DEFAULT 'Y' NOT NULL, /*未取到价格时人工输入*/
oah05       varchar2(1) DEFAULT 'Y' NOT NULL, /*B/C 类型价格互斥*/
oah06       varchar2(1) DEFAULT 'Y' NOT NULL, /*同组同类型价格互斥*/
oah07       varchar2(1) DEFAULT 'Y' NOT NULL, /*取到价格允许修改*/
oah08       varchar2(1) DEFAULT 'Y' NOT NULL /*单价可否为零*/
);

alter table oah_file add  constraint oah_pk primary key  (oah01) enable validate;
grant select on oah_file to tiptopgp;
grant update on oah_file to tiptopgp;
grant delete on oah_file to tiptopgp;
grant insert on oah_file to tiptopgp;
grant index on oah_file to public;
grant select on oah_file to ods;
