/*
================================================================================
檔案代號:lpk_file
檔案名稱:会员基本资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lpk_file
(
lpk01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员编号*/
lpk02       varchar2(1),             /*证件种类                               */
lpk03       varchar2(30),            /*证件号码                               */
lpk04       varchar2(30),            /*姓名                                   */
lpk05       date,                    /*出生日期                               */
lpk06       varchar2(1),             /*性别                                   */
lpk07       varchar2(1),             /*婚姻                                   */
lpk08       varchar2(10),            /*学历                                   */
lpk09       varchar2(10),            /*职业类别                               */
lpk10       varchar2(10),            /*会员等级                               */
lpk11       varchar2(10),            /*收入等级                               */
lpk12       varchar2(10),            /*兴趣爱好                               */
lpk13       varchar2(10),            /*会员类型                               */
lpk14       varchar2(10),            /*申请来源                               */
lpk15       varchar2(255),           /*会员地址                               */
lpk16       varchar2(10),            /*邮政编码                               */
lpk17       varchar2(20),            /*电话                                   */
lpk18       varchar2(20),            /*手机                                   */
lpk19       varchar2(80),            /*E-mail                                 */
lpkacti     varchar2(1),             /*资料有效码                             */
lpkcrat     date,                    /*资料创建日                             */
lpkdate     date,                    /*最近更改日                             */
lpkgrup     varchar2(10),            /*资料所有群                             */
lpkmodu     varchar2(10),            /*资料更改者                             */
lpkuser     varchar2(10),            /*资料所有者                             */
lpkoriu     varchar2(10),            /*资料建立者                             */
lpkorig     varchar2(10),            /*资料建立部门                           */
lpkpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lpk051      number(5),               /*出生月份                               */
lpkud01     varchar2(255),           /*自订字段-Textedit                      */
lpkud02     varchar2(40),            /*自订字段-文字                          */
lpkud03     varchar2(40),            /*自订字段-文字                          */
lpkud04     varchar2(40),            /*自订字段-文字                          */
lpkud05     varchar2(40),            /*自订字段-文字                          */
lpkud06     varchar2(40),            /*自订字段-文字                          */
lpkud07     number(15,3),            /*自订字段-数值                          */
lpkud08     number(15,3),            /*自订字段-数值                          */
lpkud09     number(15,3),            /*自订字段-数值                          */
lpkud10     number(10),              /*自订字段-整数                          */
lpkud11     number(10),              /*自订字段-整数                          */
lpkud12     number(10),              /*自订字段-整数                          */
lpkud13     date,                    /*自订字段-日期                          */
lpkud14     date,                    /*自订字段-日期                          */
lpkud15     date,                    /*自订字段-日期                          */
lpk052      number(5),               /*出生月份                               */
lpk053      number(5),               /*出生日期                               */
lpk20       varchar2(10),            /*客户编号                               */
lpk21       varchar2(1) DEFAULT ' ' NOT NULL /*会员升等提示否*/
);

alter table lpk_file add  constraint lpk_pk primary key  (lpk01) enable validate;
grant select on lpk_file to tiptopgp;
grant update on lpk_file to tiptopgp;
grant delete on lpk_file to tiptopgp;
grant insert on lpk_file to tiptopgp;
grant index on lpk_file to public;
grant select on lpk_file to ods;
