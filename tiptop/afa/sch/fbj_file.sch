/*
================================================================================
檔案代號:fbj_file
檔案名稱:资产重分类单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbj_file
(
fbj01       varchar2(20) NOT NULL,   /*出售单号                               */
fbj02       date,                    /*出售日期                               */
fbj03       varchar2(10),            /*销售客户                               */
fbj04       varchar2(10),            /*送货客户                               */
fbj05       varchar2(4),             /*币种                                   */
fbj06       number(20,10),           /*汇率                                   */
fbj07       varchar2(4),             /*税种                                   */
fbj071      number(9,4),             /*税率                                   */
fbj072      varchar2(1),             /*联数                                   */
fbj073      varchar2(1),             /*含税否                                 */
fbj08       number(20,6),            /*原币出售税前金额                       */
fbj08x      number(20,6),            /*原币出售税额                           */
fbj08t      number(20,6),            /*原币出售含税金额                       */
fbj09       number(20,6),            /*本币出售税前金额                       */
fbj09x      number(20,6),            /*本币出售税额                           */
fbj09t      number(20,6),            /*本币出售含税金额                       */
fbj10       number(20,6),            /*处份资产损益                           */
fbj11       varchar2(20),            /*发票号码                               */
fbj12       varchar2(1),             /*No Use                                 */
fbj13       varchar2(1),             /*No Use                                 */
fbj14       varchar2(20),            /*凭证号码                               */
fbj15       date,                    /*凭证日期                               */
fbjconf     varchar2(1),             /*确认码                                 */
fbjpost     varchar2(1),             /*过帐码                                 */
fbjprsw     number(5),               /*打印次数                               */
fbjuser     varchar2(10),            /*资料所有者                             */
fbjgrup     varchar2(10),            /*资料所有群                             */
fbjmodu     varchar2(10),            /*资料更改者                             */
fbjdate     date,                    /*最近更改日                             */
fbjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbjorig     varchar2(10),            /*资料建立部门                           */
fbjoriu     varchar2(10)             /*资料建立者                             */
);

alter table fbj_file add  constraint fbj_pk primary key  (fbj01) enable validate;
grant select on fbj_file to tiptopgp;
grant update on fbj_file to tiptopgp;
grant delete on fbj_file to tiptopgp;
grant insert on fbj_file to tiptopgp;
grant index on fbj_file to public;
grant select on fbj_file to ods;
