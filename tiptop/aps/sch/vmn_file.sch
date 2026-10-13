/*
================================================================================
檔案代號:vmn_file
檔案名稱:aps 途程製程維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vmn_file
(
vmn01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vmn02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vmn03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vmn04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vmn08       varchar2(60),            /*资源群组编号(机器)                     */
vmn081      varchar2(60),            /*资源群组编号(工作站)                   */
vmn09       number(1),               /*批次作业                               */
vmn12       number(9),               /*移转批量大小                           */
vmn13       number(9),               /*基准数量                               */
vmn15       number(9),               /*替代作业的优先次序                     */
vmn16       number(9),               /*批次加工上限                           */
vmn17       number(9),               /*批次加工下限                           */
vmn18       varchar2(10),            /*外包商编号                             */
vmn19       number(9),               /*批量后置时间                           */
vmn20       number(15,3),            /*单一标准人工工时                       */
vmn21       number(15,3),            /*单一标准机器工时                       */
vmnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vmnplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vmn012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vmn_file add  constraint vmn_pk primary key  (vmn01,vmn02,vmn03,vmn04,vmn012) enable validate;
grant select on vmn_file to tiptopgp;
grant update on vmn_file to tiptopgp;
grant delete on vmn_file to tiptopgp;
grant insert on vmn_file to tiptopgp;
grant index on vmn_file to public;
grant select on vmn_file to ods;
