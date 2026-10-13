/*
================================================================================
檔案代號:tqy_file
檔案名稱:提案门店资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqy_file
(
tqy01       varchar2(20) NOT NULL,   /*提案单号                               */
tqy02       number(5) NOT NULL,      /*项次                                   */
tqy03       varchar2(10),            /*门店代码                               */
tqy04       varchar2(10),            /*系统码                                 */
tqy05       varchar2(10),            /*省份代码                               */
tqy06       varchar2(10),            /*地级市代码                             */
tqy07       varchar2(10),            /*系统区域码                             */
tqy08       date,                    /*No Use                                 */
tqy09       date,                    /*No Use                                 */
tqy10       number(20,6),            /*目标税前金额合计                       */
tqy11       number(20,6),            /*目标含税金额合计                       */
tqy12       number(20,6),            /*实际税前金额合计                       */
tqy13       number(20,6),            /*实际含税金额合计                       */
tqy14       number(20,6),            /*费用合计                               */
tqy15       varchar2(50),            /*No Use                                 */
tqy16       varchar2(1),             /*No Use                                 */
tqy17       number(15,3),            /*No Use                                 */
tqy18       number(15,3),            /*No Use                                 */
tqy19       number(15,3),            /*No Use                                 */
tqy20       number(15,3),            /*No Use                                 */
tqy21       number(15,3),            /*No Use                                 */
tqy22       varchar2(1),             /*是否需要有效协议书                     */
tqy23       number(5),               /*需要协议书数量                         */
tqy24       number(5),               /*实际协议书数量                         */
tqy25       varchar2(255),           /*协议书备注                             */
tqy26       varchar2(1),             /*是否需要照片                           */
tqy27       number(5),               /*需要照片数量                           */
tqy28       number(5),               /*实际照片数量                           */
tqy29       varchar2(255),           /*照片备注                               */
tqy30       varchar2(1),             /*是否需要海报                           */
tqy31       number(5),               /*需要海报数量                           */
tqy32       number(5),               /*实际海报数量                           */
tqy33       varchar2(255),           /*海报备注                               */
tqy34       number(15,3),            /*No Use                                 */
tqy35       number(15,3),            /*No Use                                 */
tqy36       varchar2(10),            /*营运中心编号                           */
tqy37       varchar2(1),             /*生效否                                 */
tqy38       date,                    /*生效日期                               */
tqyud01     varchar2(255),           /*自订字段-Textedit                      */
tqyud02     varchar2(40),            /*自订字段-文字                          */
tqyud03     varchar2(40),            /*自订字段-文字                          */
tqyud04     varchar2(40),            /*自订字段-文字                          */
tqyud05     varchar2(40),            /*自订字段-文字                          */
tqyud06     varchar2(40),            /*自订字段-文字                          */
tqyud07     number(15,3),            /*自订字段-数值                          */
tqyud08     number(15,3),            /*自订字段-数值                          */
tqyud09     number(15,3),            /*自订字段-数值                          */
tqyud10     number(10),              /*自订字段-整数                          */
tqyud11     number(10),              /*自订字段-整数                          */
tqyud12     number(10),              /*自订字段-整数                          */
tqyud13     date,                    /*自订字段-日期                          */
tqyud14     date,                    /*自订字段-日期                          */
tqyud15     date,                    /*自订字段-日期                          */
tqyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index tqy_02 on tqy_file (tqy01,tqy03);
alter table tqy_file add  constraint tqy_pk primary key  (tqy01,tqy02) enable validate;
grant select on tqy_file to tiptopgp;
grant update on tqy_file to tiptopgp;
grant delete on tqy_file to tiptopgp;
grant insert on tqy_file to tiptopgp;
grant index on tqy_file to public;
grant select on tqy_file to ods;
