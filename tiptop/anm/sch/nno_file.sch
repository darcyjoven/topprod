/*
================================================================================
檔案代號:nno_file
檔案名稱:合约借款额度档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nno_file
(
nno01       varchar2(10) NOT NULL,   /*合约号码                               */
                                     /*合約號碼                               */
nno02       varchar2(20),            /*信贷银行                               */
                                     /*信貸銀行                               */
nno03       date,                    /*申请日期                               */
                                     /*申請日期                               */
nno04       date,                    /*核准日期                               */
nno05       date,                    /*有效日期                               */
nno06       varchar2(4),             /*申请币种                               */
                                     /*申請幣別                               */
nno07       number(20,6),            /*申请金额                               */
                                     /*申請金額                               */
nno08       number(20,6),            /*核准金额                               */
                                     /*核准金額(原幣)                         */
nno09       varchar2(1),             /*暂停否                                 */
                                     /*暫停否                                 */
nno10       varchar2(1),             /*No Use                                 */
nno11       varchar2(1),             /*No Use                                 */
nno12       varchar2(1),             /*No Use                                 */
nno13       varchar2(255),           /*备注                                   */
                                     /*MEMO   #genero 改為TEXTEDIT            */
nnouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
nnogrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
nnomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
nnodate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
nnoacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
nnoud01     varchar2(255),           /*自订字段-Textedit                      */
nnoud02     varchar2(40),            /*自订字段-文字                          */
nnoud03     varchar2(40),            /*自订字段-文字                          */
nnoud04     varchar2(40),            /*自订字段-文字                          */
nnoud05     varchar2(40),            /*自订字段-文字                          */
nnoud06     varchar2(40),            /*自订字段-文字                          */
nnoud07     number(15,3),            /*自订字段-数值                          */
nnoud08     number(15,3),            /*自订字段-数值                          */
nnoud09     number(15,3),            /*自订字段-数值                          */
nnoud10     number(10),              /*自订字段-整数                          */
nnoud11     number(10),              /*自订字段-整数                          */
nnoud12     number(10),              /*自订字段-整数                          */
nnoud13     date,                    /*自订字段-日期                          */
nnoud14     date,                    /*自订字段-日期                          */
nnoud15     date,                    /*自订字段-日期                          */
nnooriu     varchar2(10),            /*资料建立者                             */
nnoorig     varchar2(10)             /*资料建立部门                           */
);

alter table nno_file add  constraint nno_pk primary key  (nno01) enable validate;
grant select on nno_file to tiptopgp;
grant update on nno_file to tiptopgp;
grant delete on nno_file to tiptopgp;
grant insert on nno_file to tiptopgp;
grant index on nno_file to public;
grant select on nno_file to ods;
