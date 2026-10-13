/*
================================================================================
檔案代號:idm_file
檔案名稱:ICD厂商WIP资料设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idm_file
(
idm01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idm02       varchar2(10) DEFAULT ' ' NOT NULL, /*厂别 缺省为 00*/
idm03       varchar2(255),           /*档案存放位置                           */
idm04       varchar2(1),             /*no use                                 */
idm05       varchar2(1),             /*字段分隔符号                           */
idm07       varchar2(1),             /*no use                                 */
idm08       number(5),               /*序号                                   */
idm09       varchar2(1),             /*no use                                 */
idm10       varchar2(1),             /*no use                                 */
idm11       varchar2(1),             /*no use                                 */
idm12       varchar2(1),             /*no use                                 */
idm13       varchar2(1),             /*no use                                 */
idm14       varchar2(1),             /*no use                                 */
idm15       varchar2(1),             /*no use                                 */
idmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idm_file add  constraint idm_pk primary key  (idm01,idm02) enable validate;
grant select on idm_file to tiptopgp;
grant update on idm_file to tiptopgp;
grant delete on idm_file to tiptopgp;
grant insert on idm_file to tiptopgp;
grant index on idm_file to public;
grant select on idm_file to ods;
