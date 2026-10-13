/*
================================================================================
檔案代號:pias_file
檔案名稱:盘点标签明细-现有库存批/序号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pias_file
(
pias01      varchar2(20) NOT NULL,   /*标签编号                               */
pias02      varchar2(40),            /*料件编号                               */
pias03      varchar2(10),            /*仓库                                   */
pias04      varchar2(10),            /*库位                                   */
pias05      varchar2(24),            /*批号                                   */
pias06      varchar2(30) NOT NULL,   /*序号                                   */
pias07      varchar2(30) NOT NULL,   /*制造批号                               */
pias08      varchar2(10),            /*库存等级                               */
pias09      number(15,3),            /*现有库存量                             */
pias10      varchar2(4),             /*库存单位                               */
pias11      varchar2(10),            /*生成人员                               */
pias12      date,                    /*生成日期                               */
pias13      date,                    /*修正日期                               */
pias19      varchar2(1),             /*是否已作盘点[过帐]                     */
pias30      number(15,3),            /*初盘(一)-- 盘点数量                    */
pias31      varchar2(10),            /*初盘(一)-- 资料输入人员编号            */
pias32      date,                    /*初盘(一)-- 资料输入日期                */
pias33      varchar2(8),             /*初盘(一)-- 资料输入时间                */
pias34      varchar2(10),            /*初盘人员(一)                           */
pias35      date,                    /*初盘日期(一)                           */
pias40      number(15,3),            /*初盘(二)-- 盘点数量                    */
pias41      varchar2(10),            /*初盘(二)-- 资料输入人员编号            */
pias42      date,                    /*初盘(二)-- 资料输入日期                */
pias43      varchar2(8),             /*初盘(二)-- 资料输入时间                */
pias44      varchar2(10),            /*初盘人员(二)                           */
pias45      date,                    /*初盘日期(二)                           */
pias50      number(15,3),            /*复盘(一)-- 盘点数量                    */
pias51      varchar2(10),            /*复盘(一)-- 数据输入人员编号            */
pias52      date,                    /*复盘(一)-- 数据输入日期                */
pias53      varchar2(8),             /*复盘(一)-- 数据输入时间                */
pias54      varchar2(10),            /*复盘人员(一)                           */
pias55      date,                    /*复盘日期(一)                           */
pias60      number(15,3),            /*复盘(二)-- 盘点数量                    */
pias61      varchar2(10),            /*复盘(二)-- 资料输入人员编号            */
pias62      date,                    /*复盘(二)-- 资料输入日期                */
pias63      varchar2(8),             /*复盘(二)-- 资料输入时间                */
pias64      varchar2(10),            /*复盘人员(二)                           */
pias65      date,                    /*复盘日期(二)                           */
piasplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
piaslegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create        index pias_03 on pias_file (pias02,pias03,pias04,pias05,pias06,pias07);
create        index pias_02 on pias_file (pias02);
alter table pias_file add  constraint pias_pk primary key  (pias01,pias06,pias07) enable validate;
grant select on pias_file to tiptopgp;
grant update on pias_file to tiptopgp;
grant delete on pias_file to tiptopgp;
grant insert on pias_file to tiptopgp;
grant index on pias_file to public;
grant select on pias_file to ods;
