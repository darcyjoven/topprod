/*
================================================================================
檔案代號:asi_file
檔案名稱:公司科目余额暂存资料(非TIPTOP公司)
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asi_file
(
asi00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asi01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asi02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asi03       varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
asi04       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asi041      varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
asi05       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asi051      varchar2(120),           /*来源科目名称                           */
asi06       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asi07       number(5) DEFAULT '0' NOT NULL, /*期别*/
asi08       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
asi09       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
asi10       number(10) DEFAULT '0' NOT NULL, /*借方笔数*/
asi11       number(10) DEFAULT '0' NOT NULL, /*贷方笔数*/
asi12       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asi13       varchar2(10) DEFAULT ' ' NOT NULL, /*关系人编号*/
asi14       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码5值*/
asi15       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码6值*/
asi16       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码7值*/
asi17       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码8值*/
asi18       number(15,3) DEFAULT '0' NOT NULL, /*個體本位幣借方金額*/
asi19       number(15,3) DEFAULT '0' NOT NULL, /*個體本位幣貸方金額*/
asi20       varchar2(4),             /*个体本位币币种                         */
asi21       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣借方金額*/
asi22       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣貸方金額*/
asi23       varchar2(4),             /*個體功能幣幣別                         */
asi24       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
asiacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
asiconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
asidate     date,                    /*最近更改日                             */
asigrup     varchar2(10),            /*资料所有群                             */
asilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
asimodu     varchar2(10),            /*资料更改者                             */
asiorig     varchar2(10),            /*资料建立部门                           */
asioriu     varchar2(10),            /*资料建立者                             */
asipost     varchar2(1) DEFAULT ' ' NOT NULL, /*更新否*/
asiuser     varchar2(10)             /*资料所有者                             */
);

alter table asi_file add  constraint asi_pk primary key  (asi01,asi02,asi03,asi04,asi041,asi05,asi06,asi07,asi00,asi12,asi13,asi24) enable validate;
grant select on asi_file to tiptopgp;
grant update on asi_file to tiptopgp;
grant delete on asi_file to tiptopgp;
grant insert on asi_file to tiptopgp;
grant index on asi_file to public;
grant select on asi_file to ods;
