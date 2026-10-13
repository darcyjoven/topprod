/*
================================================================================
檔案代號:edd_file
檔案名稱:合拼版制程料件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edd_file
(
edd01       varchar2(20) DEFAULT ' ' NOT NULL, /*合拼版号*/
edd011      number(5) DEFAULT '0' NOT NULL, /*合拼序*/
edd013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
edd02       number(5) DEFAULT '0' NOT NULL, /*组合项次*/
edd03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料件编号*/
edd04       date DEFAULT sysdate NOT NULL, /*生效日期*/
edd05       date,                    /*失效日期                               */
edd06       number(16,8),            /*组成用量                               */
edd07       number(16,8),            /*底数                                   */
edd08       number(9,4),             /*损耗率                                 */
edd081      number(15,3),            /*固定损耗量                             */
edd082      number(9,4),             /*损耗批量                               */
edd09       varchar2(6),             /*作业编号                               */
edd10       varchar2(4),             /*发料单位                               */
edd10_fac   number(20,8),            /*发料对料件库存单位换算率               */
edd10_fac2  number(20,8),            /*发料对料件成本单位换算率               */
edd11       varchar2(20),            /*工程图号                               */
edd13       varchar2(10),            /*元件插件位置                           */
edd14       varchar2(1),             /*元件使用特性                           */
edd15       varchar2(1),             /*元件消耗特性                           */
edd16       varchar2(1),             /*取/替代特性                            */
edd17       varchar2(1),             /*特性旗标                               */
edd18       number(5),               /*元件投料时距                           */
edd19       varchar2(1),             /*工单开立展开选项                       */
edd20       number(5),               /*No Use                                 */
edd21       varchar2(1),             /*No Use                                 */
edd22       varchar2(1),             /*No Use                                 */
edd23       number(9,4),             /*选中率                                 */
edd24       varchar2(20),            /*工程变异单单号                         */
edd25       varchar2(10),            /*仓库                                   */
edd26       varchar2(10),            /*存放位置                               */
edd27       varchar2(1),             /*元件是否软体对象                       */
edd28       number(9,4),             /*发料误差允许率                         */
edd29       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
edd30       varchar2(1),             /*计算方式                               */
edd31       varchar2(1),             /*代买料否                               */
edd33       number(10),              /*款式BOM对应项次                        */
eddcomm     varchar2(10),            /*更改指令来源                           */
edddate     date,                    /*单身最近一次更改日期                   */
eddmodu     varchar2(10)             /*资料更改者                             */
);

alter table edd_file add  constraint edd_pk primary key  (edd01,edd011,edd013,edd02,edd03,edd04) enable validate;
grant select on edd_file to tiptopgp;
grant update on edd_file to tiptopgp;
grant delete on edd_file to tiptopgp;
grant insert on edd_file to tiptopgp;
grant index on edd_file to public;
grant select on edd_file to ods;
