/*
================================================================================
檔案代號:gef_file
檔案名稱:编码规则单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gef_file
(
gef01       varchar2(10) NOT NULL,   /*编码类型                               */
                                     /*編碼類別                               */
gef02       number(5) NOT NULL,      /*段次                                   */
gef03       number(5),               /*长度                                   */
                                     /*長度                                   */
gef04       varchar2(30) NOT NULL,   /*前段编码                               */
                                     /*前段編碼                               */
gef05       varchar2(1),             /*类型                                   */
                                     /*型態  1.固定值  2.獨立段  3.流水號     */
gefacti     varchar2(1),             /*资料有效码                             */
gefuser     varchar2(10),            /*资料所有者                             */
gefgrup     varchar2(10),            /*资料所有部门                           */
gefmodu     varchar2(10),            /*资料更改者                             */
gefdate     date,                    /*最近更改日                             */
geforiu     varchar2(10),            /*资料建立者                             */
geforig     varchar2(10)             /*资料建立部门                           */
);

alter table gef_file add  constraint gef_pk primary key  (gef01,gef02,gef04) enable validate;
grant select on gef_file to tiptopgp;
grant update on gef_file to tiptopgp;
grant delete on gef_file to tiptopgp;
grant insert on gef_file to tiptopgp;
grant index on gef_file to public;
grant select on gef_file to ods;
