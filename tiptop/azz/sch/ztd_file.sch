/*
================================================================================
檔案代號:ztd_file
檔案名稱:Constraint 单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ztd_file
(
ztd01       varchar2(30) NOT NULL,   /*档案代码                               */
ztd02       varchar2(80) NOT NULL,   /*数据库名称                             */
ztd03       varchar2(30) NOT NULL,   /*Constraint 名称                        */
ztd04       varchar2(1),             /*Constraint 类型                        */
ztd05       varchar2(255),           /*search condition                       */
ztd06       varchar2(30),            /*referenced schema                      */
ztd07       varchar2(30),            /*referenced constraint name             */
ztd08       varchar2(1),             /*delete rule                            */
ztd09       varchar2(1),             /*status                                 */
ztd10       varchar2(1),             /*deferrable                             */
ztd11       varchar2(1),             /*validated                              */
ztd12       varchar2(1),             /*attribute                              */
ztd13       varchar2(255),           /*Primary Key 字段                       */
ztd14       varchar2(255),           /*primarykey position                    */
ztd15       varchar2(255),           /*referenced 字段                        */
ztd16       varchar2(255),           /*referenced position                    */
ztd17       varchar2(30)             /*referenced table                       */
);

alter table ztd_file add  constraint ztd_pk primary key  (ztd01,ztd02,ztd03) enable validate;
grant select on ztd_file to tiptopgp;
grant update on ztd_file to tiptopgp;
grant delete on ztd_file to tiptopgp;
grant insert on ztd_file to tiptopgp;
grant index on ztd_file to public;
grant select on ztd_file to ods;
