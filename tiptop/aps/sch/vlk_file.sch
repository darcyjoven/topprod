/*
================================================================================
檔案代號:vlk_file
檔案名稱:平行加工變更檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlk_file
(
vlk01       varchar2(20) NOT NULL,   /*工单编号                               */
vlk02       number(5) NOT NULL,      /*变更序号                               */
vlk03       number(5) NOT NULL,      /*工艺序号                               */
vlk04       number(1) NOT NULL,      /*资源类型                               */
vlk05       number(5) NOT NULL,      /*资源项次                               */
vlk06       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vlk07       varchar2(1),             /*变更方式                               */
vlk13a      number(15,3),            /*NO USE                                 */
vlk13b      number(15,3),            /*NO USE                                 */
vlk14a      number(15,3),            /*NO USE                                 */
vlk14b      number(15,3),            /*NO USE                                 */
vlk15a      number(15,3),            /*NO USE                                 */
vlk15b      number(15,3),            /*NO USE                                 */
vlk16a      number(15,3),            /*NO USE                                 */
vlk16b      number(15,3),            /*NO USE                                 */
vlk49a      number(15,3),            /*NO USE                                 */
vlk49b      number(15,3),            /*NO USE                                 */
vlk50a      date,                    /*变更后预计开工日                       */
vlk50b      date,                    /*变更前预计开工日                       */
vlk51a      date,                    /*变更后预计完工日                       */
vlk51b      date,                    /*变更前预计完工日                       */
vlk60a      number(1),               /*变更后锁定码设定                       */
vlk60b      number(1),               /*变更前锁定码设定                       */
vlk61a      date,                    /*变更后锁定开始时间(日期 时:            */
vlk61b      date,                    /*变更前锁定开始时间(日期 时:            */
vlk62a      date,                    /*变更后锁定结束时间(日期 时:            */
vlk62b      date,                    /*变更前锁定结束时间(日期 时:            */
vlklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vlkplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vlk_file add  constraint vlk_pk primary key  (vlk01,vlk02,vlk03,vlk04,vlk05,vlk06) enable validate;
grant select on vlk_file to tiptopgp;
grant update on vlk_file to tiptopgp;
grant delete on vlk_file to tiptopgp;
grant insert on vlk_file to tiptopgp;
grant index on vlk_file to public;
grant select on vlk_file to ods;
