/*
================================================================================
檔案代號:vnd_file
檔案名稱:aps 鎖定製程時間維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vnd_file
(
vnd01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vnd02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vnd03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vnd04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vnd05       varchar2(10) NOT NULL,   /*资源编号                               */
vnd06       number(1),               /*锁定码                                 */
vnd07       date,                    /*开始时间(日期)                         */
vnd08       date,                    /*结束时间(日期)                         */
vnd09       number(1),               /*是否排程                               */
vnd10       number(1),               /*是否为平行机台任务                     */
vnd11       number(9),               /*外包时间长度（秒）                     */
vndlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vndplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vnd012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vnd_file add  constraint vnd_pk primary key  (vnd01,vnd02,vnd03,vnd04,vnd05,vnd012) enable validate;
grant select on vnd_file to tiptopgp;
grant update on vnd_file to tiptopgp;
grant delete on vnd_file to tiptopgp;
grant insert on vnd_file to tiptopgp;
grant index on vnd_file to public;
grant select on vnd_file to ods;
