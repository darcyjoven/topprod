/*
================================================================================
檔案代號:pja_file
檔案名稱:项目基本资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pja_file
(
pja01       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
pja02       varchar2(80),            /*项目名称                               */
pja03       varchar2(10),            /*版本                                   */
pja04       varchar2(10),            /*首段编码                               */
pja05       date,                    /*项目立项日期                           */
pja06       varchar2(1),             /*项目性质                               */
pja07       varchar2(4),             /*项目类型                               */
pja08       varchar2(10),            /*项目负责人                             */
pja09       varchar2(10),            /*负责部门                               */
pja091      varchar2(255),           /*内容说明                               */
pja092      varchar2(255),           /*内容说明                               */
pja093      varchar2(255),           /*内容说明                               */
pja094      varchar2(255),           /*内容说明                               */
pja10       date,                    /*预计开始日期                           */
pja11       date,                    /*预计完工日期                           */
pja12       varchar2(1),             /*活动网络否                             */
pja13       number(20,6),            /*项目预计总额                           */
pja14       varchar2(4),             /*币种                                   */
pja15       number(20,10),           /*汇率                                   */
pja16       number(15,3),            /*预计总工作量                           */
pja17       varchar2(4),             /*预计工作量单位                         */
pja18       varchar2(1),             /*WBS日期维护方式                        */
pja19       varchar2(1),             /*网络推算方式                           */
pja20       varchar2(1),             /*推算时，是否更新wbs时间                */
pja21       date,                    /*项目结案日期                           */
pja22       number(15,3),            /*no use                                 */
pja23       number(15,3),            /*no use                                 */
pja24       number(15,3),            /*no use                                 */
pja25       varchar2(1),             /*预算控管否                             */
pja26       varchar2(1),             /*no use                                 */
pja27       varchar2(1),             /*no use                                 */
pja28       varchar2(1),             /*no use                                 */
pja29       varchar2(1),             /*no use                                 */
pja30       varchar2(1),             /*no use                                 */
pjaacti     varchar2(1),             /*资料有效码                             */
pjaclose    varchar2(1),             /*结案码                                 */
pjaconf     varchar2(1),             /*确认码                                 */
pjadate     date,                    /*最近更改日                             */
pjagrup     varchar2(10),            /*资料所有部门                           */
pjamodu     varchar2(10),            /*资料更改者                             */
pjauser     varchar2(10),            /*资料所有者                             */
pja31       varchar2(1),             /*项目收入的审核方式                     */
pja32       number(20,6),
pja33       number(20,6),
pja34       number(20,6),
pjaud01     varchar2(255),           /*自订字段-Textedit                      */
pjaud02     varchar2(40),            /*自订字段-文字                          */
pjaud03     varchar2(40),            /*自订字段-文字                          */
pjaud04     varchar2(40),            /*自订字段-文字                          */
pjaud05     varchar2(40),            /*自订字段-文字                          */
pjaud06     varchar2(40),            /*自订字段-文字                          */
pjaud07     number(15,3),            /*自订字段-数值                          */
pjaud08     number(15,3),            /*自订字段-数值                          */
pjaud09     number(15,3),            /*自订字段-数值                          */
pjaud10     number(10),              /*自订字段-整数                          */
pjaud11     number(10),              /*自订字段-整数                          */
pjaud12     number(10),              /*自订字段-整数                          */
pjaud13     date,                    /*自订字段-日期                          */
pjaud14     date,                    /*自订字段-日期                          */
pjaud15     date,                    /*自订字段-日期                          */
pjaoriu     varchar2(10),            /*资料建立者                             */
pjaorig     varchar2(10)             /*资料建立部门                           */
);

alter table pja_file add  constraint pja_pk primary key  (pja01) enable validate;
grant select on pja_file to tiptopgp;
grant update on pja_file to tiptopgp;
grant delete on pja_file to tiptopgp;
grant insert on pja_file to tiptopgp;
grant index on pja_file to public;
grant select on pja_file to ods;
