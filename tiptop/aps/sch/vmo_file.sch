/*
================================================================================
檔案代號:vmo_file
檔案名稱:APS物料清单/料表维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmo_file
(
vmo01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件品号*/
vmo02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件品号*/
vmo03       number(5) DEFAULT '0' NOT NULL, /*元件序号*/
vmo08       number(1),               /*元件替代码                             */
vmo09       number(1),               /*元件替代优先顺序                       */
vmo10       number(1),               /*元件群组替代码                         */
vmo11       number(1),               /*耗尽料                                 */
vmo13       number(1),               /*替代方式                               */
vmo14       number(1),               /*展元件需求                             */
vmo15       number(1),               /*客供料                                 */
vmo16       number(1),               /*替代料供给                             */
vmo17       number(1),               /*新单开立方式                           */
vmo18       number(18,8)             /*替代比率                               */
);

alter table vmo_file add  constraint vmo_pk primary key  (vmo01,vmo02,vmo03) enable validate;
grant select on vmo_file to tiptopgp;
grant update on vmo_file to tiptopgp;
grant delete on vmo_file to tiptopgp;
grant insert on vmo_file to tiptopgp;
grant index on vmo_file to public;
grant select on vmo_file to ods;
