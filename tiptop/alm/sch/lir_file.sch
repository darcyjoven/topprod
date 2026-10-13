/*
================================================================================
檔案代號:lir_file
檔案名稱:摊位个别费用标准变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lir_file
(
lir01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
lir02       date,                    /*变更日期                               */
lir03       varchar2(10),            /*变更人                                 */
lir04       varchar2(20),            /*方案编号                               */
lir05       number(5),               /*版本号                                 */
lir06       varchar2(1) DEFAULT ' ' NOT NULL, /*方案类型*/
lir07       varchar2(20),            /*来源方案                               */
lir071      number(5),               /*来源方案版本号                         */
lir08       varchar2(10),            /*费用编号                               */
lir09       varchar2(10),            /*楼栋编号                               */
lir10       varchar2(10),            /*楼层编号                               */
lir11       varchar2(10),            /*区域编号                               */
lir12       varchar2(10),            /*小类编号                               */
lir13       varchar2(10),            /*攤位用途                               */
lir14       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lir15       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方式*/
lir16       date,                    /*变更前开始时间                         */
lir161      date,                    /*变更后开始时间                         */
lir17       date,                    /*变更前结束日期                         */
lir171      date,                    /*变更后结束日期                         */
lir18       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前延用上期费用标准*/
lir181      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后延用上期费用标准*/
lir19       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lir20       varchar2(255),           /*备注                                   */
liracti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lircond     date,                    /*审核日期                               */
lirconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lircont     varchar2(8),             /*审核时间                               */
lirconu     varchar2(10),            /*审核人员                               */
lircrat     date,                    /*资料创建日                             */
lirdate     date,                    /*最近更改日                             */
lirgrup     varchar2(10),            /*资料所有群                             */
lirlegal    varchar2(10),            /*所属法人                               */
lirmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lirmodu     varchar2(10),            /*资料更改者                             */
lirorig     varchar2(10),            /*资料建立部门                           */
liroriu     varchar2(10),            /*资料建立者                             */
lirplant    varchar2(10),            /*所属营运中心                           */
liruser     varchar2(10)             /*资料所有者                             */
);

alter table lir_file add  constraint lir_pk primary key  (lir01) enable validate;
grant select on lir_file to tiptopgp;
grant update on lir_file to tiptopgp;
grant delete on lir_file to tiptopgp;
grant insert on lir_file to tiptopgp;
grant index on lir_file to public;
grant select on lir_file to ods;
