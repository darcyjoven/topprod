/*
================================================================================
檔案代號:nad_file
檔案名稱:内部银行利率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nad_file
(
nad01       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
nad02       varchar2(1) NOT NULL,    /*计息类型                               */
                                     /*計息類型                               */
nad03       number(20,6),            /*利率                                   */
nad04       varchar2(4),             /*no use                                 */
                                     /*No Use                                 */
nadacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nadgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nadmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
naddate     date,                    /*最后更改日期                           */
                                     /*最後修改日                             */
naduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nadorig     varchar2(10),            /*资料建立部门                           */
nadoriu     varchar2(10)             /*资料建立者                             */
);

alter table nad_file add  constraint nad_pk primary key  (nad01,nad02) enable validate;
grant select on nad_file to tiptopgp;
grant update on nad_file to tiptopgp;
grant delete on nad_file to tiptopgp;
grant insert on nad_file to tiptopgp;
grant index on nad_file to public;
grant select on nad_file to ods;
