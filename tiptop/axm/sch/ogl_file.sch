/*
================================================================================
檔案代號:ogl_file
檔案名稱:装箱单资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogl_file
(
ogl01       varchar2(20),            /*通知单号                               */
ogl02       number(5),               /*通知单项次                             */
ogl03       varchar2(20) DEFAULT ' ' NOT NULL, /*裝箱單號*/
ogl04       number(5) DEFAULT '0' NOT NULL, /*项次*/
ogl05       number(10),              /*数量                                   */
ogl06       varchar2(255),           /*说明                                   */
ogl07       varchar2(20),            /*箱号                                   */
ogl08       varchar2(20),            /*出货单号                               */
ogl09       varchar2(20),            /*条形码                                 */
oglcond     date,                    /*审核日期                               */
oglconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
oglconu     varchar2(10),            /*审核人                                 */
oglcrat     date,                    /*资料创建日                             */
ogldate     date,                    /*最近更改日                             */
oglgrup     varchar2(10),            /*资料所有部门                           */
ogllegal    varchar2(10),            /*所属法人                               */
oglmodu     varchar2(10),            /*资料更改者                             */
ogloriu     varchar2(10),            /*资料建立者                             */
oglplant    varchar2(10),            /*所属工厂                               */
ogluser     varchar2(10)             /*资料所有者                             */
);

alter table ogl_file add  constraint ogl_pk primary key  (ogl03,ogl04) enable validate;
grant select on ogl_file to tiptopgp;
grant update on ogl_file to tiptopgp;
grant delete on ogl_file to tiptopgp;
grant insert on ogl_file to tiptopgp;
grant index on ogl_file to public;
grant select on ogl_file to ods;
