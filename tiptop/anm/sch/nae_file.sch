/*
================================================================================
檔案代號:nae_file
檔案名稱:内部银行利息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nae_file
(
nae01       varchar2(30) NOT NULL,   /*银行帐号                               */
nae02       varchar2(1),             /*计息类型                               */
nae03       number(20,6),            /*利率                                   */
nae04       date NOT NULL,           /*起息日                                 */
nae05       date NOT NULL,           /*止息日                                 */
nae06       number(20,6),            /*利息金额                               */
nae07       varchar2(20),            /*计息正式单号                           */
nae08       varchar2(10),            /*所属营运中心                           */
naeconf     varchar2(1),             /*确认码                                 */
naeacti     varchar2(1),             /*资料有效码                             */
naeuser     varchar2(10),            /*资料所有者                             */
naegrup     varchar2(10),            /*资料所有部门                           */
naemodu     varchar2(10),            /*资料更改者                             */
naedate     date,                    /*最后更改日期                           */
nae09       varchar2(2),             /*拨入变动码                             */
naeoriu     varchar2(10),            /*资料建立者                             */
naeorig     varchar2(10)             /*资料建立部门                           */
);

alter table nae_file add  constraint nae_pk primary key  (nae01,nae04,nae05) enable validate;
grant select on nae_file to tiptopgp;
grant update on nae_file to tiptopgp;
grant delete on nae_file to tiptopgp;
grant insert on nae_file to tiptopgp;
grant index on nae_file to public;
grant select on nae_file to ods;
