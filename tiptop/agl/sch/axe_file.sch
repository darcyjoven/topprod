/*
================================================================================
檔案代號:axe_file
檔案名稱:合并财报会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axe_file
(
axe01       varchar2(10) NOT NULL,   /*公司编号                               */
axe02       varchar2(10),            /*No Use                                 */
axe021      varchar2(20),            /*No Use                                 */
axe03       varchar2(20),            /*No Use                                 */
axe04       varchar2(24) NOT NULL,   /*公司科目编号                           */
axe05       varchar2(255),           /*公司科目名称                           */
axe06       varchar2(24),            /*母公司科目编号                         */
axe07       varchar2(1),             /*No Use                                 */
axe08       varchar2(1),             /*No Use                                 */
axe09       varchar2(1),             /*No Use                                 */
axe10       varchar2(1),             /*No Use                                 */
axeacti     varchar2(1),             /*资料有效码                             */
axeuser     varchar2(10),            /*资料所有者                             */
axegrup     varchar2(10),            /*资料所有部门                           */
axemodu     varchar2(10),            /*资料更改者                             */
axedate     date,                    /*最近更改日                             */
axe11       varchar2(1),             /*再衡量汇率类型                         */
axe12       varchar2(1),             /*换算汇率类型                           */
axe00       varchar2(5) NOT NULL,    /*帐套                                   */
axe13       varchar2(10) NOT NULL,   /*集团代号                               */
axeorig     varchar2(10),            /*资料建立部门                           */
axeoriu     varchar2(10)             /*资料建立者                             */
);

alter table axe_file add  constraint axe_pk primary key  (axe00,axe01,axe04,axe13) enable validate;
grant select on axe_file to tiptopgp;
grant update on axe_file to tiptopgp;
grant delete on axe_file to tiptopgp;
grant insert on axe_file to tiptopgp;
grant index on axe_file to public;
grant select on axe_file to ods;
