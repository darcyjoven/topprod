/*
================================================================================
檔案代號:imy_file
檔案名稱:营运中心调拨拨入单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imy_file
(
imy01       varchar2(20) NOT NULL,   /*拨入单号                               */
                                     /*撥入單號                               */
imy02       number(5) NOT NULL,      /*拨入项次                               */
                                     /*撥入項次                               */
imy03       varchar2(20),            /*拨出单号                               */
                                     /*撥出單號                               */
imy04       number(5),               /*拨出项次                               */
                                     /*撥出項次                               */
imy05       varchar2(20),            /*调拨单号                               */
                                     /*調撥單號                               */
imy06       number(5),               /*调拨项次                               */
                                     /*調撥項次                               */
imy07       varchar2(10),            /*拨入仓库                               */
                                     /*撥入倉庫別                             */
imy08       varchar2(10),            /*拨入库位别                             */
                                     /*撥入儲位別                             */
imy09       varchar2(24),            /*拨入批号                               */
                                     /*撥入批號                               */
imy10       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
imy11       varchar2(10),            /*项目号码                               */
                                     /*專案號碼                               */
imy12       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
imy13       varchar2(10),            /*库存等级                               */
                                     /*庫存等級                               */
imy14       varchar2(4),             /*外观编号                               */
                                     /*外觀代號                               */
imy15       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
imy16       number(15,3),            /*本次实收数量                           */
                                     /*本次實收數量                           */
imy17       varchar2(4),             /*实收单位                               */
                                     /*實收單位                               */
imy18       number(20,8),            /*拨出/拨入转换率                        */
                                     /*撥出/撥入轉換率                        */
imy19       date,                    /*审核日期                               */
                                     /*確認日期                               */
imy20       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
imy21       varchar2(1),             /*No Use                                 */
imy22       varchar2(1),             /*No Use                                 */
imy23       varchar2(1),             /*No Use                                 */
imy24       varchar2(4),             /*实收单位一                             */
imy25       number(15,3),            /*实收单位一数量                         */
imy26       number(20,8),            /*单位一拨出/拨入转换率                  */
imy27       varchar2(4),             /*实收单位二                             */
imy28       number(15,3),            /*实收单位二数量                         */
imy29       number(20,8),            /*单位二拨出/拨入转换率                  */
imy31       number(20,8),            /*单位一转换率(与库存单位)               */
imy32       number(20,8),            /*单位二转换率(与库存单位)               */
imyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index imy_03 on imy_file (imy05,imy06);
create        index imy_02 on imy_file (imy03,imy04);
alter table imy_file add  constraint imy_pk primary key  (imy01,imy02) enable validate;
grant select on imy_file to tiptopgp;
grant update on imy_file to tiptopgp;
grant delete on imy_file to tiptopgp;
grant insert on imy_file to tiptopgp;
grant index on imy_file to public;
grant select on imy_file to ods;
