/*
================================================================================
檔案代號:pny_file
檔案名稱:集团采购底稿分配
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pny_file
(
pny01       varchar2(10),            /*采购中心代码                           */
pny02       varchar2(1),             /*资料来源 (1.依各厂抛转的请购           */
pny03       varchar2(20),            /*抛转底稿序号 /mrp版本                  */
pny04       varchar2(10),            /*需求营运中心                           */
pny05       varchar2(20),            /*请购单号  /mrp版本                     */
pny06       number(10),              /*请购单项次 /序号                       */
pny07       varchar2(1),             /*类型 1.调拨  2.采购                    */
pny08       varchar2(10),            /*拨出营运中心                           */
pny09       varchar2(10),            /*拨入营运中心                           */
pny10       date,                    /*预计交货日                             */
pny11       varchar2(4),             /*单位一                                 */
pny12       number(20,8),            /*单位一转换率                           */
pny13       number(15,3),            /*单位一数量                             */
pny14       varchar2(4),             /*单位二                                 */
pny15       number(20,8),            /*单位二转换率                           */
pny16       number(15,3),            /*单位二数量                             */
pny17       varchar2(4),             /*分配单位(pmn07)                        */
pny18       number(20,8),            /*分配单位/库存单位转换率 (pmn0          */
pny19       number(15,3),            /*分配数量 (pmn20)                       */
pny20       varchar2(8),             /*内部流程代码                           */
pny21       varchar2(20),            /*单据编号                               */
pny22       number(5),               /*单据项次                               */
pny23       number(5),               /*打印次数(先开字段但程序先不            */
pny24       varchar2(10),            /*供应商代码                             */
pnyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index pny_01 on pny_file (pny01,pny02,pny03,pny04,pny05,pny06);
grant select on pny_file to tiptopgp;
grant update on pny_file to tiptopgp;
grant delete on pny_file to tiptopgp;
grant insert on pny_file to tiptopgp;
grant index on pny_file to public;
grant select on pny_file to ods;
