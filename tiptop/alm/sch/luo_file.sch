/*
================================================================================
檔案代號:luo_file
檔案名稱:支出单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luo_file
(
luo01       varchar2(20) DEFAULT ' ' NOT NULL, /*支出单号*/
luo02       date,                    /*单据日期                               */
luo03       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
luo04       varchar2(20),            /*来源单号                               */
luo05       varchar2(10),            /*商户编号                               */
luo06       varchar2(20),            /*摊位编号                               */
luo07       varchar2(20),            /*合约编号                               */
luo08       number(5),               /*合同版本号                             */
luo09       number(20,6),            /*支出金额                               */
luo10       number(20,6),            /*已退金额                               */
luo11       number(20,6),            /*清算金额                               */
luo12       varchar2(10),            /*业务人员                               */
luo13       varchar2(10),            /*部门编号                               */
luo14       varchar2(255),           /*备注                                   */
luo15       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
luoacti     varchar2(1) NOT NULL,    /*资料有效码                             */
luocond     date,                    /*审核日期                               */
luoconf     varchar2(1) NOT NULL,    /*确认码                                 */
luocont     varchar2(8),             /*审核时间                               */
luoconu     varchar2(10),            /*审核人员                               */
luocrat     date,                    /*资料创建日                             */
luodate     date,                    /*最近更改日                             */
luogrup     varchar2(10),            /*资料所有群                             */
luolegal    varchar2(10) NOT NULL,   /*法人                                   */
luomksg     varchar2(1) NOT NULL,    /*是否签核                               */
luomodu     varchar2(10),            /*资料更改者                             */
luoorig     varchar2(10),            /*资料建立部门                           */
luooriu     varchar2(10),            /*资料建立者                             */
luoplant    varchar2(10) NOT NULL,   /*门店编号                               */
luouser     varchar2(10)             /*资料所有者                             */
);

alter table luo_file add  constraint luo_pk primary key  (luo01) enable validate;
grant select on luo_file to tiptopgp;
grant update on luo_file to tiptopgp;
grant delete on luo_file to tiptopgp;
grant insert on luo_file to tiptopgp;
grant index on luo_file to public;
grant select on luo_file to ods;
