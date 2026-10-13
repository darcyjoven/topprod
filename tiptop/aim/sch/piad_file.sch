/*
================================================================================
檔案代號:piad_file
檔案名稱:盘点标签明细-现有库存刻号/BIN资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table piad_file
(
piad01      varchar2(20) DEFAULT ' ' NOT NULL, /*标签编号*/
piad02      varchar2(40),            /*料件编号                               */
piad03      varchar2(10),            /*仓库                                   */
piad04      varchar2(10),            /*库位                                   */
piad05      varchar2(24),            /*批号                                   */
piad06      varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
piad07      varchar2(5) DEFAULT ' ' NOT NULL, /*BIN*/
piad08      varchar2(10),            /*库存等级                               */
piad09      number(15,3) NOT NULL,   /*现有库存量                             */
piad10      varchar2(4),             /*库存单位                               */
piad11      varchar2(10),            /*生成人员                               */
piad12      date,                    /*生成日期                               */
piad13      date,                    /*修正日期                               */
piad19      varchar2(1) DEFAULT ' ' NOT NULL, /*是否已作盘点[过帐]*/
piad30      number(15,3) DEFAULT '0' NOT NULL, /*初盘(一)-- 盘点数量*/
piad31      varchar2(10),            /*初盘(一)-- 资料输入人员编号            */
piad32      date,                    /*初盘(一)-- 资料输入日期                */
piad33      varchar2(8),             /*初盘(一)-- 资料输入时间                */
piad34      varchar2(10),            /*初盘人员(一)                           */
piad35      date,                    /*初盘日期(一)                           */
piad40      number(15,3) DEFAULT '0' NOT NULL, /*初盘(二)-- 盘点数量*/
piad41      varchar2(10),            /*初盘(二)-- 资料输入人员编号            */
piad42      date,                    /*初盘(二)-- 资料输入日期                */
piad43      varchar2(8),             /*初盘(二)-- 资料输入时间                */
piad44      varchar2(10),            /*初盘人员(二)                           */
piad45      date,                    /*初盘日期(二)                           */
piad50      number(15,3) DEFAULT '0' NOT NULL, /*复盘(一)-- 盘点数量*/
piad51      varchar2(10),            /*复盘(一)-- 数据输入人员编号            */
piad52      date,                    /*复盘(一)-- 数据输入日期                */
piad53      varchar2(8),             /*复盘(一)-- 数据输入时间                */
piad54      varchar2(10),            /*复盘人员(一)                           */
piad55      date,                    /*复盘日期(一)                           */
piad60      number(15,3) DEFAULT '0' NOT NULL, /*复盘(二)-- 盘点数量*/
piad61      varchar2(10),            /*复盘(二)-- 资料输入人员编号            */
piad62      date,                    /*复盘(二)-- 资料输入日期                */
piad63      varchar2(8),             /*复盘(二)-- 资料输入时间                */
piad64      varchar2(10),            /*复盘人员(二)                           */
piad65      date,                    /*复盘日期(二)                           */
piadlegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
piadplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create        index piad_02 on piad_file (piad02);
create        index piad_03 on piad_file (piad02,piad03,piad04,piad05,piad06,piad07);
alter table piad_file add  constraint piad_pk primary key  (piad01,piad06,piad07) enable validate;
grant select on piad_file to tiptopgp;
grant update on piad_file to tiptopgp;
grant delete on piad_file to tiptopgp;
grant insert on piad_file to tiptopgp;
grant index on piad_file to public;
grant select on piad_file to ods;
