/*
================================================================================
檔案代號:tlfb_file
檔案名稱:条码扫瞄异动记录档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tlfb_file
(
tlfb01      varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
tlfb02      varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
tlfb03      varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
tlfb04      varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
tlfb05      number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
tlfb06      number(5) DEFAULT '1' NOT NULL, /*异动类型*/
tlfb07      varchar2(20),            /*来源单号                               */
tlfb08      number(5),               /*来源项次                               */
tlfb09      varchar2(20),            /*目的单号                               */
tlfb10      number(5),               /*目的项次                               */
tlfb11      varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
tlfb12      varchar2(20),            /*无线装置固定IP                         */
tlfb13      varchar2(10) DEFAULT ' ' NOT NULL, /*PDA操作人代号*/
tlfb14      date DEFAULT sysdate NOT NULL, /*扫瞄日期*/
tlfb15      varchar2(12) DEFAULT ' ' NOT NULL, /*时间(时:分:秒.毫秒)*/
tlfb16      varchar2(20) DEFAULT ' ' NOT NULL, /*AP Server*/
tlfb17      varchar2(10),            /*杂收理由码                             */
tlfb18      varchar2(10),            /*产品分类码                             */
tlfbgrup    varchar2(10),            /*资料所有群                             */
tlfblegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
tlfbplant   varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
tlfbuser    varchar2(10),            /*资料所有者                             */
tlfb19      varchar2(1) DEFAULT 'Y' NOT NULL, /*扣帐资料否*/
tlfb905     varchar2(20),            /*异动单号                               */
tlfb906     number(5)                /*异动项次                               */
);

grant select on tlfb_file to tiptopgp;
grant update on tlfb_file to tiptopgp;
grant delete on tlfb_file to tiptopgp;
grant insert on tlfb_file to tiptopgp;
grant index on tlfb_file to public;
grant select on tlfb_file to ods;
