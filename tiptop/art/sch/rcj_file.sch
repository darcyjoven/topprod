/*
================================================================================
檔案代號:rcj_file
檔案名稱:流通零售系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table rcj_file
(
rcj00       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE(0)*/
rcj01       date DEFAULT sysdate NOT NULL, /*百货专柜核算关帐日期*/
rcjud01     varchar2(255),           /*自订字段                               */
rcjud02     varchar2(40),            /*自订字段                               */
rcjud03     varchar2(40),            /*自订字段                               */
rcjud04     varchar2(40),            /*自订字段                               */
rcjud05     varchar2(40),            /*自订字段                               */
rcjud06     varchar2(255),           /*自订字段                               */
rcjud07     number(15,3),            /*自订字段                               */
rcjud08     number(15,3),            /*自订字段                               */
rcjud09     number(15,3),            /*自订字段                               */
rcjud10     number(10),              /*自订字段                               */
rcjud11     number(10),              /*自订字段                               */
rcjud12     number(10),              /*自订字段                               */
rcjud13     date,                    /*自订字段                               */
rcjud14     date,                    /*自订字段                               */
rcjud15     date,                    /*自订字段                               */
rcj02       varchar2(10),            /*券库存杂项报废理由码                   */
rcj03       varchar2(1) DEFAULT '2' NOT NULL, /*券库存管理仓库*/
                                     /*1.成本仓, 2.非成本仓                   */
rcj04       varchar2(10),
rcj05       varchar2(10),            /*卡销售理由码                           */
rcj06       varchar2(10),            /*卡储值理由码                           */
rcj07       varchar2(10) DEFAULT ' ',/*卡退款理由码                           */
rcj08       varchar2(10),            /*换卡理由码                             */
rcj09       varchar2(1) DEFAULT ' ' NOT NULL, /*配送自动完成否*/
rcj10       number(5) DEFAULT '180' NOT NULL, /*查询时间范围*/
rcj11       varchar2(1) DEFAULT 'Y' NOT NULL, /*使用退货申请作业*/
rcj12       varchar2(1) DEFAULT ' ' NOT NULL, /*异店取货销售归属*/
rcj13       varchar2(1) DEFAULT ' ' NOT NULL,
rcj14       number(5),
rcj15       number(5),
rcj16       varchar2(1) DEFAULT 'N' NOT NULL /*使用会员升等/降等否*/
);

alter table rcj_file add  constraint rcj_pk primary key  (rcj00) enable validate;
grant select on rcj_file to tiptopgp;
grant update on rcj_file to tiptopgp;
grant delete on rcj_file to tiptopgp;
grant insert on rcj_file to tiptopgp;
grant index on rcj_file to public;
grant select on rcj_file to ods;
