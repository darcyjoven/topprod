/*
================================================================================
檔案代號:vnm_file
檔案名稱:APS途程製程指定工具
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vnm_file
(
vnm00       varchar2(40) NOT NULL,   /*品号                                   */
vnm01       varchar2(80) NOT NULL,   /*工艺路线                               */
vnm02       varchar2(60) NOT NULL,   /*工艺路线中的加工序号                   */
vnm03       varchar2(60) NOT NULL,   /*作业编号                               */
vnm04       varchar2(60) NOT NULL,   /*工模具群组编号                         */
vnm05       number(1) NOT NULL,      /*类型                                   */
vnm06       number(9),               /*替代码                                 */
vnmlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vnmplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vnm012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vnm_file add  constraint vnm_pk primary key  (vnm00,vnm01,vnm02,vnm03,vnm04,vnm05,vnm012) enable validate;
grant select on vnm_file to tiptopgp;
grant update on vnm_file to tiptopgp;
grant delete on vnm_file to tiptopgp;
grant insert on vnm_file to tiptopgp;
grant index on vnm_file to public;
grant select on vnm_file to ods;
