/*
================================================================================
檔案代號:lin_file
檔案名稱:费用标准变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lin_file
(
lin00       varchar2(1) DEFAULT ' ' NOT NULL, /*方案类型*/
lin01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
lin02       date,                    /*变更日期                               */
lin03       varchar2(10),            /*变更人                                 */
lin04       varchar2(20),            /*方案编号                               */
lin05       number(5),               /*版本号                                 */
lin06       varchar2(10),            /*费用编号                               */
lin07       varchar2(10),            /*楼栋编号                               */
lin08       varchar2(10),            /*楼层编号                               */
lin09       varchar2(10),            /*区域编号                               */
lin10       varchar2(10),            /*小类编号                               */
lin11       varchar2(10),            /*攤位用途                               */
lin12       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lin13       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方式*/
lin14       date,                    /*变更前开始日期                         */
lin141      date,                    /*变更后开始日期                         */
lin15       date,                    /*变更前结束日期                         */
lin151      date,                    /*变更后结束日期                         */
lin16       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前延用上期费用标准*/
lin161      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后延用上期费用标准*/
lin17       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lin18       varchar2(255),           /*备注                                   */
linacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lincond     date,                    /*审核日期                               */
linconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lincont     varchar2(8),             /*审核时间                               */
linconu     varchar2(10),            /*审核人员                               */
lincrat     date,                    /*资料创建日                             */
lindate     date,                    /*最近更改日                             */
lingrup     varchar2(10),            /*资料所有群                             */
linlegal    varchar2(10),            /*法人                                   */
linmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
linmodu     varchar2(10),            /*资料更改者                             */
linorig     varchar2(10),            /*资料建立部门                           */
linoriu     varchar2(10),            /*资料建立者                             */
linplant    varchar2(10),            /*門店代號                               */
linuser     varchar2(10)             /*资料所有者                             */
);

alter table lin_file add  constraint lin_pk primary key  (lin01) enable validate;
grant select on lin_file to tiptopgp;
grant update on lin_file to tiptopgp;
grant delete on lin_file to tiptopgp;
grant insert on lin_file to tiptopgp;
grant index on lin_file to public;
grant select on lin_file to ods;
