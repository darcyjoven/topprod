/*
================================================================================
檔案代號:hrbm_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbm_file
(
hrbm01      varchar2(20) NOT NULL,   /*公司编号                               */
hrbm02      varchar2(20) NOT NULL,   /*项目类型                               */
hrbm03      varchar2(20) NOT NULL,   /*项目编号                               */
hrbm04      varchar2(30) NOT NULL,   /*项目名称                               */
hrbm05      number(4,2),             /*核算量                                 */
hrbm06      varchar2(20) NOT NULL,   /*核算单位                               */
hrbm07      varchar2(1) NOT NULL,    /*有效                                   */
hrbm08      varchar2(255),           /*备注                                   */
hrbm09      varchar2(1) NOT NULL,    /*限制补卡                               */
hrbm10      number(2),               /*补卡次数                               */
hrbm11      number(3),               /*考核起始分钟数                         */
hrbm12      number(3),               /*考核结束分钟数                         */
hrbm13      varchar2(1) NOT NULL,    /*跳过班次中的休息时间                   */
hrbm14      varchar2(1) NOT NULL,    /*跳过休息班次                           */
hrbm15      varchar2(255) NOT NULL,  /*享受津贴的班次                         */
hrbm16      varchar2(255) NOT NULL,  /*不享受津贴的班次                       */
hrbm17      varchar2(5) NOT NULL,    /*享受津贴时间点                         */
hrbm18      varchar2(1) NOT NULL,    /*津贴核算正常上班时数                   */
hrbm19      varchar2(1) NOT NULL,    /*津贴核算平日加班时数                   */
hrbm20      varchar2(1) NOT NULL,    /*津贴核算节假日加班时数                 */
hrbm21      varchar2(1) NOT NULL,    /*以时间点后的时数核算                   */
hrbm22      number(15,3),            /*最小核算津贴时数                       */
hrbm23      varchar2(1) NOT NULL,    /*自动设置调休                           */
hrbm24      varchar2(1) NOT NULL,    /*次月开始调休                           */
hrbm25      varchar2(20) NOT NULL,   /*有效调休区间                           */
hrbm26      number(2,2),             /*调休倍数                               */
hrbm27      number(2),               /*调休优先级                             */
hrbmud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbmud02    varchar2(40),            /*自订栏位-文字                          */
hrbmud03    varchar2(40),            /*自订栏位-文字                          */
hrbmud04    varchar2(40),            /*自订栏位-文字                          */
hrbmud05    varchar2(40),            /*自订栏位-文字                          */
hrbmud06    varchar2(40),            /*自订栏位-文字                          */
hrbmud07    number(15,3),            /*自订栏位-数值                          */
hrbmud08    number(15,3),            /*自订栏位-数值                          */
hrbmud09    number(15,3),            /*自订栏位-数值                          */
hrbmud10    number(10),              /*自订栏位-整数                          */
hrbmud11    number(10),              /*自订栏位-整数                          */
hrbmud12    number(10),              /*自订栏位-整数                          */
hrbmud13    date,                    /*自订栏位-日期                          */
hrbmud14    date,                    /*自订栏位-日期                          */
hrbmud15    date,                    /*自订栏位-日期                          */
hrbmuser    varchar2(10),            /*资料所有者                             */
hrbmgrup    varchar2(10),            /*资料所有群                             */
hrbmmodu    varchar2(10),            /*资料更改者                             */
hrbmdate    date,                    /*最近修改日                             */
hrbmorig    varchar2(10),            /*资料建立部门                           */
hrbmoriu    varchar2(10),            /*资料建立者                             */
hrbm28      varchar2(1),             /*扣除工作时间                           */
hrbm29      number(15,3),            /*最大核算津贴时数                       */
hrbm30      varchar2(1),             /*冲抵次日班次时间                       */
hrbm31      number(2,2),             /*冲抵时数                               */
hrbm32      varchar2(1),             /*免班                                   */
hrbm33      varchar2(20),            /*适用人群                               */
hrbm34      varchar2(1),             /*标识位                                 */
hrbm35      varchar2(20),            /*填充假别                               */
hrbm36      varchar2(1)
);

alter table hrbm_file add  constraint tpc_hrbm_pk primary key  (hrbm03) enable validate;
grant select on hrbm_file to tiptopgp;
grant update on hrbm_file to tiptopgp;
grant delete on hrbm_file to tiptopgp;
grant insert on hrbm_file to tiptopgp;
grant index on hrbm_file to public;
grant select on hrbm_file to ods;
