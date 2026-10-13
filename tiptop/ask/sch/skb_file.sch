/*
================================================================================
檔案代號:skb_file
檔案名稱:预包装档
檔案目的:预包装单身档 双档单身
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skb_file
(
skb01       varchar2(20) DEFAULT ' ' NOT NULL, /*预包装单号*/
skb02       number(10) DEFAULT '0' NOT NULL, /*项次*/
skb03       varchar2(20),            /*订单单号                               */
skb04       number(10),              /*订单项次                               */
skb05       varchar2(40),            /*料号                                   */
skb06       number(5),               /*序号                                   */
skb07       varchar2(1),             /*包装类型                               */
skb08       varchar2(20),            /*包装方式编号                           */
skb09       number(10),              /*每箱装数                               */
skb10       number(5),               /*箱数                                   */
skb11       varchar2(1),             /*包装箱号字首(default="0")              */
skb12       number(10),              /*起始包装箱号                           */
skb13       number(10),              /*截止包装箱号                           */
skb14       number(15,3),            /*产品数量                               */
skb15       number(15,3),            /*单位净重(kg)                           */
skb16       number(15,3),            /*单位毛重(kg)                           */
skb17       number(15,3),            /*单位材积(cuft)                         */
skb18       number(15,3),            /*总净重(kg)                             */
skb19       number(15,3),            /*总毛重(kg)                             */
skb20       number(15,3),            /*总材积(cuft)                           */
skbud01     varchar2(255),           /*自订字段-Textedit                      */
skbud02     varchar2(40),            /*自订字段-文字                          */
skbud03     varchar2(40),            /*自订字段-文字                          */
skbud04     varchar2(40),            /*自订字段-文字                          */
skbud05     varchar2(40),            /*自订字段-文字                          */
skbud06     varchar2(40),            /*自订字段-文字                          */
skbud07     number(15,3),            /*自订字段-数值                          */
skbud08     number(15,3),            /*自订字段-数值                          */
skbud09     number(15,3),            /*自订字段-数值                          */
skbud10     number(10),              /*自订字段-整数                          */
skbud11     number(10),              /*自订字段-整数                          */
skbud12     number(10),              /*自订字段-整数                          */
skbud13     date,                    /*自订字段-日期                          */
skbud14     date,                    /*自订字段-日期                          */
skbud15     date,                    /*自订字段-日期                          */
skbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skb_file add  constraint skb_pk primary key  (skb01,skb02) enable validate;
grant select on skb_file to tiptopgp;
grant update on skb_file to tiptopgp;
grant delete on skb_file to tiptopgp;
grant insert on skb_file to tiptopgp;
grant index on skb_file to public;
grant select on skb_file to ods;
