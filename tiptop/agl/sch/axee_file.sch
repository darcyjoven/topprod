/*
================================================================================
檔案代號:axee_file
檔案名稱:合并后财报会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axee_file
(
axee00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
axee01      varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
axee02      varchar2(1),             /*No Use                                 */
axee021     varchar2(1),             /*No Use                                 */
axee03      varchar2(1),             /*No Use                                 */
axee04      varchar2(24) DEFAULT ' ' NOT NULL, /*公司科目编号*/
axee05      varchar2(255),           /*公司科目名称                           */
axee06      varchar2(24),            /*母公司会计科目编号                     */
axee07      varchar2(1),             /*No Use                                 */
axee08      varchar2(1),             /*No Use                                 */
axee09      varchar2(1),             /*No Use                                 */
axee10      varchar2(1),             /*No Use                                 */
axee11      varchar2(1),             /*再衡量汇率类型                         */
axee12      varchar2(1),             /*换算汇率类型                           */
axee13      varchar2(10) NOT NULL,   /*集团代号                               */
axeeacti    varchar2(1),             /*资料有效码                             */
axeedate    date,                    /*最近更改日                             */
axeegrup    varchar2(10),            /*资料所有部门                           */
axeemodu    varchar2(10),            /*资料更改者                             */
axeeuser    varchar2(10),            /*资料所有者                             */
axeeorig    varchar2(10),            /*资料建立部门                           */
axeeoriu    varchar2(10)             /*资料建立者                             */
);

alter table axee_file add  constraint axee_pk primary key  (axee00,axee01,axee04,axee13) enable validate;
grant select on axee_file to tiptopgp;
grant update on axee_file to tiptopgp;
grant delete on axee_file to tiptopgp;
grant insert on axee_file to tiptopgp;
grant index on axee_file to public;
grant select on axee_file to ods;
