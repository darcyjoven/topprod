/*
================================================================================
檔案代號:ooy_file
檔案名稱:应收系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ooy_file
(
ooyslip     varchar2(5) NOT NULL,    /*单别                                   */
                                     /*單別                                   */
ooydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
ooyauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否 (Y/N)                       */
ooymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
ooykind     varchar2(1),             /*No Use                                 */
                                     /*編號方式                               */
ooyconf     varchar2(1),             /*立即审核                               */
                                     /*立即確認                               */
ooyprit     varchar2(1),             /*立即打印                               */
                                     /*立即列印                               */
ooydmy1     varchar2(1),             /*抛转凭证                               */
                                     /*拋轉傳票                               */
ooytype     varchar2(2),             /*单据性质                               */
                                     /*單據性質                               */
                                     /* 11.訂金應收       21.退貨折讓待抵     */
                                     /* 12.出貨應收       22.雜項待抵         */
                                     /* 13.尾款應收       23.預收(訂金)       */
                                     /* 14.雜項應收       24.暫收(溢收)       */
                                     /* 25.折扣           30.沖帳單           */
                                     /* 31.非應收發票     40.收狀單           */
ooy10       varchar2(1),             /*发票是否限额                           */
                                     /*發票是否限額(Y/N)          for 稅控系統*/
ooy11       number(20,6),            /*发票限额                               */
                                     /*發票限額                   for 稅控系統*/
ooyapr      varchar2(1),             /*需签核                                 */
ooydmy2     varchar2(1),             /*红冲否(Y/N)                            */
ooyacti     varchar2(1),             /*资料有效码                             */
ooyglcr     varchar2(1),             /*是否直接抛转总帐                       */
ooygslp     varchar2(5),             /*总帐单别                               */
ooygslp1    varchar2(5),             /*总帐第二单别                           */
ooydmy3     varchar2(1),             /*是否自动生成内部银行帐户资             */
                                     /*For 內部帳戶                           */
ooyud01     varchar2(255),           /*自订字段                               */
ooyud02     varchar2(40),            /*自订字段                               */
ooyud03     varchar2(40),            /*自订字段                               */
ooyud04     varchar2(40),            /*自订字段                               */
ooyud05     varchar2(40),            /*自订字段                               */
ooyud06     varchar2(255),           /*自订字段                               */
ooyud07     number(15,3),            /*自订字段                               */
ooyud08     number(15,3),            /*自订字段                               */
ooyud09     number(15,3),            /*自订字段                               */
ooyud10     number(10),              /*自订字段                               */
ooyud11     number(10),              /*自订字段                               */
ooyud12     number(10),              /*自订字段                               */
ooyud13     date,                    /*自订字段                               */
ooyud14     date,                    /*自订字段                               */
ooyud15     date                     /*自订字段                               */
);

alter table ooy_file add  constraint ooy_pk primary key  (ooyslip) enable validate;
grant select on ooy_file to tiptopgp;
grant update on ooy_file to tiptopgp;
grant delete on ooy_file to tiptopgp;
grant insert on ooy_file to tiptopgp;
grant index on ooy_file to public;
grant select on ooy_file to ods;
