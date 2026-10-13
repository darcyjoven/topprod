/*
================================================================================
檔案代號:pnn_file
檔案名稱:采购分配底稿档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnn_file
(
pnn01       varchar2(20) NOT NULL,   /*请购单号                               */
                                     /*請購單號                               */
pnn02       number(5) NOT NULL,      /*请购项次                               */
                                     /*請購項次                               */
pnn03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
pnn05       varchar2(10) NOT NULL,   /*厂商编号                               */
                                     /*廠商編號                               */
pnn06       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
pnn07       number(12,3),            /*分配率                                 */
pnn08       number(12,3),            /*替代量率                               */
                                     /*替代量率(單位替代量)                   */
pnn09       number(15,3),            /*原分配量                               */
pnn10       number(20,6),            /*采购单价                               */
                                     /*採購單價                               */
pnn11       date,                    /*到厂日期                               */
                                     /*到廠日期                               */
pnn12       varchar2(4),             /*采购单位                               */
                                     /*採購單位                               */
pnn13       varchar2(1),             /*替代特性                               */
pnn14       varchar2(40),            /*替代料件                               */
pnn15       varchar2(10),            /*采购员                                 */
                                     /*採購員                                 */
pnn16       varchar2(1),             /*修正否                                 */
pnn17       number(20,8),            /*转换率                                 */
                                     /*轉換率                                 */
pnn18       varchar2(20),            /*Blanket PO单号                         */
                                     /*Blanket PO單號 add 90/09/05            */
pnn19       number(5),               /*Blanket PO项次                         */
                                     /*Blanket PO Line No. add 90/09/05       */
pnn20       number(20,8),            /*换算因子                               */
                                     /*轉換因子       add 90/09/05            */
                                     /*本欄位為採購單位/Blanket PO單位的轉換率*/
pnn10t      number(20,6),            /*含税单价                               */
pnn30       varchar2(4),             /*单位一                                 */
pnn31       number(20,8),            /*单位一换算率(与采购单位)               */
pnn32       number(15,3),            /*单位一数量                             */
pnn33       varchar2(4),             /*单位二                                 */
pnn34       number(20,8),            /*单位二换算率(与采购单位)               */
pnn35       number(15,3),            /*单位二数量                             */
pnn36       varchar2(4),             /*计价单位                               */
pnn37       number(15,3),            /*计价数量                               */
pnn38       number(20,6),            /*税前金额                               */
pnn38t      number(20,6),            /*含税金额                               */
pnnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pnn919      varchar2(50)             /*计画批号                               */
);

create        index pnn_02 on pnn_file (pnn01,pnn02);
alter table pnn_file add  constraint pnn_pk primary key  (pnn01,pnn02,pnn03,pnn05,pnn06) enable validate;
grant select on pnn_file to tiptopgp;
grant update on pnn_file to tiptopgp;
grant delete on pnn_file to tiptopgp;
grant insert on pnn_file to tiptopgp;
grant index on pnn_file to public;
grant select on pnn_file to ods;
