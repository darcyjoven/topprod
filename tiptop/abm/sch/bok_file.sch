/*
================================================================================
檔案代號:bok_file
檔案名稱:正式bom底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bok_file
(
bok01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料件编号*/
bok02       number(10) DEFAULT '0' NOT NULL, /*组合项次*/
bok03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料件编号*/
bok04       date DEFAULT sysdate NOT NULL, /*生效日期*/
bok05       date,                    /*失效日期                               */
bok06       number(20,8),            /*组成用量                               */
bok07       number(20,8),            /*底数                                   */
bok08       number(9,4),             /*损耗率                                 */
bok09       varchar2(10),            /*作业编号                               */
bok10       varchar2(4),             /*发料单位                               */
bok10_fac   number(20,8),            /*发料对料件库存单位换算率               */
bok10_fac2  number(20,8),            /*发料对料件成本单位换算率               */
bok11       varchar2(20),            /*工程图号                               */
bok13       varchar2(20),            /*元件插件位置                           */
bok14       varchar2(1),             /*元件插件位置                           */
bok15       varchar2(1),             /*元件使用特性                           */
bok16       varchar2(1),             /*取/替代特性                            */
bok17       varchar2(1),             /*特性旗标                               */
bok18       number(10),              /*元件投料时距                           */
bok19       varchar2(1),             /*工单开立展开选项                       */
bok20       varchar2(1),             /*no use                                 */
bok21       varchar2(1),             /*no use                                 */
bok22       varchar2(1),             /*no use                                 */
bok23       number(9,4),             /*选中率                                 */
bok24       varchar2(20),            /*工程变异单单号                         */
bok25       varchar2(10),            /*仓库                                   */
bok26       varchar2(10),            /*存放位置                               */
bok27       varchar2(1),             /*元件是否软体对象                       */
bok28       number(9,4),             /*发料误差允许率                         */
bok29       varchar2(20),            /*特性代码                               */
bok30       varchar2(1),             /*计算方式                               */
bok31       varchar2(20) DEFAULT ' ' NOT NULL, /*主件料件编号*/
bok32       number(10) DEFAULT '0' NOT NULL, /*项次*/
bok33       number(10) DEFAULT '0' NOT NULL, /*款式bom项次*/
bokcomm     varchar2(20),            /*更改指令来源                           */
bokdate     date,                    /*单身最近一次资料更改者                 */
bokmodu     varchar2(10),            /*单身最近一次资料更改者                 */
bok34       varchar2(1)              /*代买料否                               */
);

alter table bok_file add  constraint bok_pk primary key  (bok01,bok31,bok32) enable validate;
grant select on bok_file to tiptopgp;
grant update on bok_file to tiptopgp;
grant delete on bok_file to tiptopgp;
grant insert on bok_file to tiptopgp;
grant index on bok_file to public;
grant select on bok_file to ods;
