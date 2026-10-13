/*
================================================================================
檔案代號:rxp_file
檔案名稱:商品寄送/送货单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxp_file
(
rxp00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别*/
                                     /*Doc. Type 1-Storage 2-Delivery         */
rxp01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxp02       date,                    /*办理日期                               */
rxp03       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
                                     /*Source Category 1-Bg Sale 2-POS Sale   */
rxp04       varchar2(20),            /*来源单号                               */
rxp05       date,                    /*交易日期                               */
rxp06       varchar2(10),            /*POS机号                                */
rxp07       varchar2(40),            /*POS交易号                              */
rxp08       varchar2(10),            /*客户代码                               */
rxp09       varchar2(1) DEFAULT ' ' NOT NULL, /*客户类型*/
                                     /*Customer Class. 1.Paynow Customer 2.Account Customer*/
rxp10       varchar2(20),            /*会员卡号                               */
rxp11       varchar2(10),            /*顾客姓名                               */
rxp12       varchar2(20),            /*顾客电话                               */
rxp13       varchar2(1) DEFAULT ' ' NOT NULL, /*证件类型*/
rxp14       varchar2(20),            /*证件号码                               */
rxp15       varchar2(80),            /*送货地址                               */
rxp16       varchar2(10),            /*经办人员                               */
rxp17       varchar2(255),           /*备注                                   */
rxpacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rxpcond     date,                    /*审核日期                               */
rxpconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
rxpcont     varchar2(8),             /*审核时间                               */
rxpconu     varchar2(10),            /*审核人员                               */
rxpcrat     date,                    /*资料创建日                             */
rxpdate     date,                    /*最近更改日                             */
rxpgrup     varchar2(10),            /*资料所有部门                           */
rxplegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxpmodu     varchar2(10),            /*资料更改者                             */
rxporig     varchar2(10),            /*资料建立部门                           */
rxporiu     varchar2(10),            /*资料建立者                             */
rxpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxpuser     varchar2(10)             /*资料所有者                             */
);

alter table rxp_file add  constraint rxp_pk primary key  (rxp00,rxp01) enable validate;
grant select on rxp_file to tiptopgp;
grant update on rxp_file to tiptopgp;
grant delete on rxp_file to tiptopgp;
grant insert on rxp_file to tiptopgp;
grant index on rxp_file to public;
grant select on rxp_file to ods;
