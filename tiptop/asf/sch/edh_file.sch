/*
================================================================================
檔案代號:edh_file
檔案名稱:PBI制程料件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edh_file
(
edh01       varchar2(20) DEFAULT ' ' NOT NULL, /*PBI单号*/
edh011      number(5) DEFAULT '0' NOT NULL, /*PBI项次*/
edh013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
edh02       number(5) DEFAULT '0' NOT NULL, /*组合项次*/
edh03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料件编号*/
edh04       date DEFAULT sysdate NOT NULL, /*生效日期*/
edh05       date,                    /*失效日期                               */
edh06       number(16,8),            /*组成用量                               */
edh07       number(16,8),            /*底数                                   */
edh08       number(9,4),             /*损耗率                                 */
edh081      number(15,3) DEFAULT '0' NOT NULL, /*固定损耗量*/
edh082      number(9,4),             /*损耗批量                               */
edh09       varchar2(6),             /*作业编号                               */
edh10       varchar2(4),             /*发料单位                               */
edh10_fac   number(20,8),            /*发料对料件库存单位换算率               */
edh10_fac2  number(20,8),            /*发料对料件成本单位换算率               */
edh11       varchar2(20),            /*工程图号                               */
edh13       varchar2(10),            /*元件插件位置                           */
edh14       varchar2(1) DEFAULT ' ' NOT NULL, /*元件使用特性*/
edh15       varchar2(1) DEFAULT ' ' NOT NULL, /*元件消耗特性*/
edh16       varchar2(1) DEFAULT ' ' NOT NULL, /*取/替代特性*/
edh17       varchar2(1) DEFAULT ' ' NOT NULL, /*特性旗标*/
edh18       number(5),               /*元件投料时距                           */
edh19       varchar2(1) DEFAULT ' ' NOT NULL, /*工单开立展开选项*/
edh20       number(5),               /*No Use                                 */
edh21       varchar2(1),             /*No Use                                 */
edh22       varchar2(1),             /*No Use                                 */
edh23       number(9,4),             /*选中率                                 */
edh24       varchar2(20),            /*工程变异单单号                         */
edh25       varchar2(10),            /*仓库                                   */
edh26       varchar2(10),            /*存放位置                               */
edh27       varchar2(1) DEFAULT ' ' NOT NULL, /*元件是否软体对象*/
edh28       number(9,4),             /*发料误差允许率                         */
edh29       varchar2(20),            /*特性代码                               */
edh30       varchar2(1) DEFAULT ' ' NOT NULL, /*计算方式*/
edh31       varchar2(1) DEFAULT ' ' NOT NULL, /*代买料否*/
edh33       number(10),              /*款式BOM对应项次                        */
edhcomm     varchar2(10),            /*更改指令来源                           */
edhdate     date,                    /*最近更改日                             */
edhmodu     varchar2(10)             /*资料更改者                             */
);

alter table edh_file add  constraint edh_pk primary key  (edh01,edh011,edh013,edh02,edh03,edh04) enable validate;
grant select on edh_file to tiptopgp;
grant update on edh_file to tiptopgp;
grant delete on edh_file to tiptopgp;
grant insert on edh_file to tiptopgp;
grant index on edh_file to public;
grant select on edh_file to ods;
