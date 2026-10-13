/*
================================================================================
檔案代號:lil_file
檔案名稱:费用标准设置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lil_file
(
lil00       varchar2(1) DEFAULT ' ' NOT NULL, /*方案类型*/
lil01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lil02       number(5) DEFAULT '0' NOT NULL, /*版本号*/
lil03       date,                    /*方案日期                               */
lil04       varchar2(10),            /*费用编号                               */
lil05       varchar2(10),            /*楼栋编号                               */
lil06       varchar2(10),            /*楼层编号                               */
lil07       varchar2(10),            /*区域编号                               */
lil08       varchar2(10),            /*小类编号                               */
lil09       varchar2(10),            /*攤位用途                               */
lil10       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lil11       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方式*/
lil12       date,                    /*开始日期                               */
lil13       date,                    /*结束日期                               */
lil14       varchar2(1) DEFAULT ' ' NOT NULL, /*延用上期费用标准*/
lil15       varchar2(10),            /*录入人员                               */
lil16       date,                    /*输入日期                               */
lil17       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lil18       varchar2(10),            /*终止人                                 */
lil19       date,                    /*终止日期                               */
lil20       varchar2(255),           /*备注                                   */
lilacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lilcond     date,                    /*审核日期                               */
lilconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lilcont     varchar2(8),             /*审核时间                               */
lilconu     varchar2(10),            /*审核人员                               */
lilcrat     date,                    /*资料创建日                             */
lildate     date,                    /*最近更改日                             */
lilgrup     varchar2(10),            /*资料所有群                             */
lillegal    varchar2(10),            /*法人                                   */
lilmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lilmodu     varchar2(10),            /*资料更改者                             */
lilorig     varchar2(10),            /*资料建立部门                           */
liloriu     varchar2(10),            /*资料建立者                             */
lilplant    varchar2(10),            /*门店编号                               */
liluser     varchar2(10)             /*资料所有者                             */
);

alter table lil_file add  constraint lil_pk primary key  (lil01) enable validate;
grant select on lil_file to tiptopgp;
grant update on lil_file to tiptopgp;
grant delete on lil_file to tiptopgp;
grant insert on lil_file to tiptopgp;
grant index on lil_file to public;
grant select on lil_file to ods;
