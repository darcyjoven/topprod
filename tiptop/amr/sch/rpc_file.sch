/*
================================================================================
檔案代號:rpc_file
檔案名稱:独立需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rpc_file
(
rpc01       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
rpc02       varchar2(20) NOT NULL,   /*销售单号                               */
                                     /*銷售單號                               */
                                     /*預測資料時, 此欄位可以不填             */
rpc03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rpc04       number(5),               /*批次                                   */
rpc10       varchar2(4),             /*需求类型                               */
                                     /*需求類別                               */
rpc11       number(5),               /*需求特性                               */
                                     /*Requirement Feature                    */
                                     /*Choice list as follow:                 */
                                     /*1:Sales Forecast                       */
                                     /*2:The Other Forecast of Not Sales      */
                                     /*3:Customer Order(MFG)                  */
                                     /*4:The Other Requirement of Not Customer Order(MFG)*/
                                     /*5:Orders between Plants(MFG)           */
                                     /*6:Customer Order(OM)                   */
                                     /*7:The Other Requirement of Not Customer Order(OM)*/
                                     /*8:Orders between Plants(OM)            */
                                     /*9.Customer Quotation List(OM)          */
rpc12       date,                    /*需求日期                               */
rpc13       number(15,3),            /*需求数量                               */
                                     /*需求數量                               */
rpc131      number(15,3),            /*出货数量                               */
                                     /*出貨數量                               */
rpc14       number(15,3),            /*最后装配工单备量(FAS allocated)        */
                                     /*最後裝配工單備量(FAS allocated)        */
rpc15       varchar2(10),            /*仓库编号                               */
                                     /*倉庫編號                               */
rpc16       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rpc16_fac   number(20,8),            /*需求单位/库存单位换算因子              */
                                     /*需求單位/庫存單位轉換因子              */
rpc17       varchar2(1000),          /*项目号码                               */
                                     /*專案號碼                               */
rpcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
rpcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rpcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
rpcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
rpcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rpc18       varchar2(1),             /*确认码                                 */
rpc19       varchar2(1),             /*结案码                                 */
rpc20       date,                    /*结案日期                               */
rpc21       date NOT NULL,           /*单据日期                               */
rpcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rpclegal    varchar2(10) NOT NULL,   /*所属法人                               */
rpcorig     varchar2(10),            /*资料建立部门                           */
rpcoriu     varchar2(10),            /*资料建立者                             */
ta_rpc01    varchar2(40),            /*成品料号                               */
ta_rpc02    number(15,3),            /*成品需求数量                           */
ta_rpc03    number(15,3),            /*成品已耗用数量                         */
ta_rpc04    varchar2(10),
ta_rpc05    varchar2(40),
ta_rpc06    varchar2(40),
ta_rpc07    number(15,3),
ta_rpc08    number(15,3),
ta_rpc09    date,
ta_rpc10    date
);

create        index rpc_01 on rpc_file (rpc01,rpc10,rpc02,rpc03,rpc04);
create        index rpc_03 on rpc_file (rpc01,rpc02,rpc03,rpc04,rpc12);
create        index rpc_02 on rpc_file (rpc01);
alter table rpc_file add  constraint rpc_pk primary key  (rpc02,rpc03,rpc21) enable validate;
grant select on rpc_file to tiptopgp;
grant update on rpc_file to tiptopgp;
grant delete on rpc_file to tiptopgp;
grant insert on rpc_file to tiptopgp;
grant index on rpc_file to public;
grant select on rpc_file to ods;
