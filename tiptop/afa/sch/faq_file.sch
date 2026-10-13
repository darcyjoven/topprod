/*
================================================================================
檔案代號:faq_file
檔案名稱:固定资产资本化单据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table faq_file
(
faq01       varchar2(20) NOT NULL,   /*单号                                   */
faq02       date,                    /*资本化日期                             */
faq03       varchar2(10),            /*原因码                                 */
faq04       varchar2(4),             /*No Use                                 */
faq05       varchar2(2),             /*No Use                                 */
faq06       varchar2(20),            /*凭证号码                               */
faq07       date,                    /*凭证日期                               */
faqconf     varchar2(1),             /*审核否                                 */
faqpost     varchar2(1),             /*过帐否                                 */
faqprsw     number(5),               /*打印次数                               */
faquser     varchar2(10),            /*资料所有者                             */
faqgrup     varchar2(10),            /*资料所有部门                           */
faqmodu     varchar2(10),            /*资料更改者                             */
faqdate     date,                    /*最近更改日                             */
faqud01     varchar2(255),           /*自订字段-Textedit                      */
faqud02     varchar2(40),            /*自订字段-文字                          */
faqud03     varchar2(40),            /*自订字段-文字                          */
faqud04     varchar2(40),            /*自订字段-文字                          */
faqud05     varchar2(40),            /*自订字段-文字                          */
faqud06     varchar2(40),            /*自订字段-文字                          */
faqud07     number(15,3),            /*自订字段-数值                          */
faqud08     number(15,3),            /*自订字段-数值                          */
faqud09     number(15,3),            /*自订字段-数值                          */
faqud10     number(10),              /*自订字段-整数                          */
faqud11     number(10),              /*自订字段-整数                          */
faqud12     number(10),              /*自订字段-整数                          */
faqud13     date,                    /*自订字段-日期                          */
faqud14     date,                    /*自订字段-日期                          */
faqud15     date,                    /*自订字段-日期                          */
faqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
faqoriu     varchar2(10),            /*资料建立者                             */
faqorig     varchar2(10),            /*资料建立部门                           */
faq062      varchar2(20),            /*传票编号(财签二)                       */
faq072      date                     /*传票日期(财签二)                       */
);

create        index faq_02 on faq_file (faq06);
alter table faq_file add  constraint faq_pk primary key  (faq01) enable validate;
grant select on faq_file to tiptopgp;
grant update on faq_file to tiptopgp;
grant delete on faq_file to tiptopgp;
grant insert on faq_file to tiptopgp;
grant index on faq_file to public;
grant select on faq_file to ods;
