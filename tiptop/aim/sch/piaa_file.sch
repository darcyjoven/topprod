/*
================================================================================
檔案代號:piaa_file
檔案名稱:盘点标签明细-「现有库存多单位」资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table piaa_file
(
piaa00      varchar2(1),             /*多单位形态                             */
                                     /*1.Parent/Child  2.Reference Unit       */
piaa01      varchar2(20) NOT NULL,   /*标签编号                               */
piaa02      varchar2(40),            /*料件编号                               */
piaa03      varchar2(10),            /*仓库                                   */
piaa04      varchar2(10),            /*库位                                   */
piaa05      varchar2(24),            /*批号                                   */
piaa06      varchar2(10),            /*库存等级                               */
piaa07      varchar2(24),            /*仓位会计科目                           */
piaa08      number(15,3),            /*现有库存量                             */
piaa09      varchar2(4) NOT NULL,    /*多单位库存单位                         */
piaa10      number(20,8),            /*多单位库存单位与料件库存单             */
piaa11      varchar2(10),            /*生成人员                               */
piaa12      date,                    /*生成日期                               */
piaa13      date,                    /*修正日期                               */
piaa14      date,                    /*打印日期                               */
piaa15      number(5),               /*打印次数                               */
piaa16      varchar2(1),             /*空白标签否                             */
piaa17      varchar2(1),             /*当前尚未使用                           */
piaa18      varchar2(1),             /*当前尚未使用                           */
piaa19      varchar2(1),             /*是否已作盘点「过帐」                   */
piaa30      number(15,3),            /*初盘（一）-- 盘点数量                  */
piaa31      varchar2(10),            /*初盘（一）-- 资料录入人员编            */
piaa32      date,                    /*初盘（一）-- 资料录入日期              */
piaa33      varchar2(8),             /*初盘（一）-- 资料录入时间              */
piaa34      varchar2(10),            /*初盘人员(一)                           */
piaa35      date,                    /*初盘日期(一)                           */
piaa40      number(15,3),            /*初盘（二）-- 盘点数量                  */
piaa41      varchar2(10),            /*初盤（二）-- 資料錄入人員編            */
piaa42      date,                    /*初盤（二）-- 資料錄入日期              */
piaa43      varchar2(8),             /*初盤（二）-- 資料錄入時間              */
piaa44      varchar2(10),            /*初盘人员(二)                           */
piaa45      date,                    /*初盘日期(二)                           */
piaa50      number(15,3),            /*复盘（一）-- 盘点数量                  */
piaa51      varchar2(10),            /*复盘（一）-- 资料录入人员编            */
piaa52      date,                    /*复盘（一）-- 资料录入日期              */
piaa53      varchar2(8),             /*复盘（一）-- 资料录入时间              */
piaa54      varchar2(10),            /*复盘人员(一)                           */
piaa55      date,                    /*复盘日期(一)                           */
piaa60      number(15,3),            /*复盘（二）-- 盘点数量                  */
piaa61      varchar2(10),            /*复盘（二）-- 资料录入人员编            */
piaa62      date,                    /*复盘（二）-- 资料录入日期              */
piaa63      varchar2(8),             /*复盘（二）-- 资料录入时间              */
piaa64      varchar2(10),            /*复盘人员(二)                           */
piaa65      date,                    /*复盘日期(二)                           */
piaa66      number(20,6),            /*标准成本                               */
piaa67      number(20,6),            /*现时成本                               */
piaa68      number(20,6),            /*缺省成本                               */
piaa900     varchar2(4),             /*保税盘点位置                           */
piaa901     varchar2(1),             /*用户自行定义                           */
piaa902     varchar2(1),             /*用户自行定义                           */
piaa903     varchar2(1),             /*用户自行定义                           */
piaa930     varchar2(10),            /*成本中心                               */
piaa931     varchar2(10),            /*底稿类型                               */
piaaplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
piaalegal   varchar2(10) NOT NULL,   /*所属法人                               */
piaa70      varchar2(10)             /*理由码                                 */
);

create        index piaa_03 on piaa_file (piaa02,piaa03,piaa04,piaa05);
create        index piaa_02 on piaa_file (piaa02);
alter table piaa_file add  constraint piaa_pk primary key  (piaa01,piaa09) enable validate;
grant select on piaa_file to tiptopgp;
grant update on piaa_file to tiptopgp;
grant delete on piaa_file to tiptopgp;
grant insert on piaa_file to tiptopgp;
grant index on piaa_file to public;
grant select on piaa_file to ods;
