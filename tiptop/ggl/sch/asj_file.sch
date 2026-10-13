/*
================================================================================
檔案代號:asj_file
檔案名稱:调整与销除分录底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asj_file
(
asj00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
asj01       varchar2(20) DEFAULT ' ' NOT NULL, /*凭证编号*/
asj02       date,                    /*单据日期                               */
asj03       number(5) DEFAULT '0' NOT NULL, /*调整年度*/
asj04       number(5) DEFAULT '0' NOT NULL, /*调整月份*/
asj05       varchar2(10),            /*族群编号                               */
asj06       varchar2(10),            /*上层公司编号                           */
asj07       varchar2(5),             /*上层公司帐套                           */
asj08       varchar2(1) DEFAULT '1' NOT NULL, /*来源码*/
asj081      varchar2(1) DEFAULT ' ' NOT NULL, /*冲销类型*/
asj09       varchar2(1) DEFAULT 'N' NOT NULL, /*换汇差额调整否*/
asj10       varchar2(255),           /*备注                                   */
asj11       number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
asj12       number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
asj13       varchar2(20),            /*NO USE                                 */
asj14       varchar2(1),             /*no use                                 */
asj15       varchar2(1),             /*no use                                 */
asj16       varchar2(1),             /*no use                                 */
asj17       varchar2(1),             /*no use                                 */
asj18       varchar2(1),             /*no use                                 */
asj19       varchar2(1),             /*no use                                 */
asj20       varchar2(1),             /*no use                                 */
asj21       varchar2(10),            /*版本                                   */
asjconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
asjdate     date,                    /*最近更改日                             */
asjgrup     varchar2(10),            /*资料所有群                             */
asjlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
asjmodu     varchar2(10),            /*资料更改者                             */
asjorig     varchar2(10),            /*资料建立部门                           */
asjoriu     varchar2(10),            /*资料建立者                             */
asjuser     varchar2(10)             /*资料所有者                             */
);

create        index asj_02 on asj_file (asj02);
alter table asj_file add  constraint asj_pk primary key  (asj00,asj01) enable validate;
grant select on asj_file to tiptopgp;
grant update on asj_file to tiptopgp;
grant delete on asj_file to tiptopgp;
grant insert on asj_file to tiptopgp;
grant index on asj_file to public;
grant select on asj_file to ods;
