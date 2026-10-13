/*
================================================================================
檔案代號:brb_file
檔案名稱:制程产品结构资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table brb_file
(
brb01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料件编号*/
brb011      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
brb012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
brb013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
brb02       number(5) DEFAULT '0' NOT NULL, /*组合项次*/
brb03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料件编号*/
brb04       date DEFAULT sysdate NOT NULL, /*生效日期*/
brb05       date,                    /*失效日期                               */
brb06       number(16,8),            /*组成用量                               */
brb07       number(16,8),            /*底数                                   */
brb08       number(9,4),             /*变动损耗率                             */
brb081      number(15,3),            /*固定损耗量                             */
brb082      number(9,4),             /*损耗批量                               */
brb09       varchar2(6),             /*作业编号                               */
brb10       varchar2(4),             /*发料单位                               */
brb10_fac   number(20,8),            /*发料对料件库存单位换算率               */
brb10_fac2  number(20,8),            /*发料对料件成本单位换算率               */
brb11       varchar2(20),            /*工程图号                               */
brb13       varchar2(10),            /*元件插件位置                           */
brb14       varchar2(1),             /*元件使用特性                           */
brb15       varchar2(1),             /*元件消耗特性                           */
brb16       varchar2(1),             /*取/替代特性                            */
brb17       varchar2(1),             /*特性旗标                               */
brb18       number(5),               /*元件投料时距                           */
brb19       varchar2(1),             /*工单开立展开选项                       */
brb20       number(5),               /*No Use                                 */
brb21       varchar2(1),             /*No Use                                 */
brb22       varchar2(1),             /*No Use                                 */
brb23       number(9,4),             /*选中率                                 */
brb24       varchar2(20),            /*工程变异单单号                         */
brb25       varchar2(10),            /*仓库                                   */
brb26       varchar2(10),            /*存放位置                               */
brb27       varchar2(1),             /*元件是否软体对象                       */
brb28       number(9,4),             /*发料误差允许率                         */
brb29       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
brb30       varchar2(1),             /*计算方式                               */
brb31       varchar2(1),             /*代买料否                               */
brb33       number(10) DEFAULT '0' NOT NULL, /*款式BOM对应项次*/
brbcomm     varchar2(10),            /*更改指令来源                           */
brbdate     date,                    /*单身最近一次更改日期                   */
brbmodu     varchar2(10)             /*资料更改者                             */
);

alter table brb_file add  constraint brb_pk primary key  (brb01,brb02,brb03,brb04,brb29,brb011,brb012,brb013) enable validate;
grant select on brb_file to tiptopgp;
grant update on brb_file to tiptopgp;
grant delete on brb_file to tiptopgp;
grant insert on brb_file to tiptopgp;
grant index on brb_file to public;
grant select on brb_file to ods;
