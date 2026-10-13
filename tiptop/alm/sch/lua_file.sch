/*
================================================================================
檔案代號:lua_file
檔案名稱:费用单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lua_file
(
lua01       varchar2(20) DEFAULT ' ' NOT NULL, /*费用单编号*/
lua02       varchar2(2),             /*no use                                 */
lua03       varchar2(1) DEFAULT ' ', /*费用单来源                             */
lua04       varchar2(20),            /*合约编号                               */
lua05       varchar2(1) DEFAULT ' ' NOT NULL, /*内部客户*/
lua06       varchar2(20),            /*客户编号                               */
lua061      varchar2(20),            /*客户简称                               */
lua07       varchar2(20),            /*摊位号                                 */
lua08       number(20,6) DEFAULT '0',/*税前总金额                             */
lua08t      number(20,6) DEFAULT '0',/*含税总金额                             */
lua09       date,                    /*单据日期                               */
lua10       varchar2(1) DEFAULT ' ' NOT NULL, /*系统自动生成*/
lua11       varchar2(1) DEFAULT ' ', /*来源作业                               */
lua12       varchar2(20),            /*单据号                                 */
lua13       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lua14       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lua15       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lua16       varchar2(10),            /*审核人                                 */
lua17       date,                    /*审核日期                               */
lua18       varchar2(60),            /*备注                                   */
lua19       varchar2(10),            /*来源营运中心                           */
lua20       varchar2(20),            /*合同版本号                             */
lua21       varchar2(4),             /*税种                                   */
lua22       number(9,4),             /*税率                                   */
lua23       varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
lua24       varchar2(20),            /*财务单号                               */
lua27       date,                    /*大月结日期                             */
lua28       date,                    /*应收报表计租起始日期                   */
lua29       date,                    /*应收报表计租截止日期                   */
lua30       date,                    /*费用起始日期                           */
lua31       date,                    /*费用截止日期                           */
luaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
luacrat     date,                    /*资料创建日                             */
luadate     date,                    /*最近更改日                             */
luagrup     varchar2(10),            /*资料所有群                             */
lualegal    varchar2(10) NOT NULL,   /*法人                                   */
luamodu     varchar2(10),            /*资料更改者                             */
luaplant    varchar2(10) NOT NULL,   /*门店编号                               */
luauser     varchar2(10),            /*资料所有者                             */
luaoriu     varchar2(10),            /*资料建立者                             */
luaorig     varchar2(10),            /*资料建立部门                           */
lua32       varchar2(1) DEFAULT ' ' NOT NULL, /*客户来源*/
lua33       number(5),               /*账期                                   */
lua34       date,                    /*出账日                                 */
lua35       number(20,6),            /*已收金额                               */
lua36       number(20,6),            /*清算金额                               */
lua37       varchar2(1) DEFAULT ' ' NOT NULL, /*直接收款*/
lua38       varchar2(10),            /*业务人员                               */
lua39       varchar2(10)             /*部门编号                               */
);

alter table lua_file add  constraint lua_pk primary key  (lua01) enable validate;
grant select on lua_file to tiptopgp;
grant update on lua_file to tiptopgp;
grant delete on lua_file to tiptopgp;
grant insert on lua_file to tiptopgp;
grant index on lua_file to public;
grant select on lua_file to ods;
