/*
================================================================================
檔案代號:lip_file
檔案名稱:摊位个别标准费用设置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lip_file
(
lip01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lip02       number(5),               /*版本号                                 */
lip03       date,                    /*方案日期                               */
lip04       varchar2(1) DEFAULT ' ' NOT NULL, /*方案类型*/
lip05       varchar2(20),            /*来源方案                               */
lip06       varchar2(10),            /*费用编号                               */
lip07       varchar2(10),            /*楼栋编号                               */
lip08       varchar2(10),            /*楼层编号                               */
lip09       varchar2(10),            /*区域编号                               */
lip10       varchar2(10),            /*小类编号                               */
lip11       varchar2(10),            /*攤位用途                               */
lip12       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lip13       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方式*/
lip14       date,                    /*开始日期                               */
lip15       date,                    /*结束日期                               */
lip16       varchar2(1) DEFAULT ' ' NOT NULL, /*延用上期费用标准*/
lip17       varchar2(10),            /*输入人                                 */
lip18       date,                    /*输入日期                               */
lip19       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lip20       varchar2(10),            /*终止人                                 */
lip21       date,                    /*终止日期                               */
lip22       varchar2(255),           /*备注                                   */
lipacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lipcond     date,                    /*审核日期                               */
lipconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lipcont     varchar2(8),             /*审核时间                               */
lipconu     varchar2(10),            /*审核人员                               */
lipcrat     date,                    /*资料创建日                             */
lipdate     date,                    /*最近更改日                             */
lipgrup     varchar2(10),            /*资料所有群                             */
liplegal    varchar2(10),            /*所属法人                               */
lipmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lipmodu     varchar2(10),            /*资料更改者                             */
liporig     varchar2(10),            /*资料建立部门                           */
liporiu     varchar2(10),            /*资料建立者                             */
lipplant    varchar2(10),            /*所属营运中心                           */
lip051      number(5),               /*来源版本号                             */
lipuser     varchar2(10)             /*资料所有者                             */
);

alter table lip_file add  constraint lip_pk primary key  (lip01) enable validate;
grant select on lip_file to tiptopgp;
grant update on lip_file to tiptopgp;
grant delete on lip_file to tiptopgp;
grant insert on lip_file to tiptopgp;
grant index on lip_file to public;
grant select on lip_file to ods;
