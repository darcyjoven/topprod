/*
================================================================================
檔案代號:imq_file
檔案名稱:还料明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imq_file
(
imq01       varchar2(20) NOT NULL,   /*还料单号                               */
                                     /*還料單號                               */
imq02       number(5) NOT NULL,      /*还料项次                               */
                                     /*還料項次                               */
imq03       varchar2(20),            /*借料单号                               */
                                     /*借料單號                               */
imq04       number(5),               /*借料项次                               */
                                     /*借料項次                               */
imq05       varchar2(40),            /*偿还料件                               */
                                     /*償還料件                               */
imq06       varchar2(4),             /*还料单位                               */
                                     /*還料單位                               */
imq06_fac   number(20,8),            /*借料/还料单位转换率                    */
                                     /*借料/還料單位轉換率                    */
imq07       number(15,3),            /*还料数量                               */
                                     /*還料數量                               */
imq08       varchar2(10),            /*还料仓库编号                           */
                                     /*還料倉庫編號                           */
imq09       varchar2(10),            /*还料库位编号                           */
                                     /*還料儲位編號                           */
imq10       varchar2(24),            /*还料批号                               */
                                     /*還料批號                               */
imq11       number(20,6),            /*实际单位成本                           */
                                     /*實際單位成本                           */
imq12       number(20,6),            /*实偿金额                               */
                                     /*實償金額                               */
imq13       number(20,6),            /*已请款金额                             */
                                     /*已請款金額                             */
imq14       varchar2(1),             /*No Use                                 */
imq15       varchar2(1),             /*检验否                                 */
imq16       varchar2(1),             /*No Use                                 */
imq17       varchar2(1),             /*No Use                                 */
imq18       varchar2(1),             /*No Use                                 */
imq19       varchar2(1),             /*No Use                                 */
imq20       varchar2(4),             /*单位一                                 */
imq21       number(20,8),            /*单位一转换率(与库存单位)               */
imq22       number(15,3),            /*单位一数量                             */
imq23       varchar2(4),             /*单位二                                 */
imq24       number(20,8),            /*单位二转换率(与库存单位)               */
imq25       number(15,3),            /*单位二数量                             */
imq930      varchar2(10),            /*成本中心                               */
imqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
imq26       varchar2(10)             /*理由码                                 */
);

alter table imq_file add  constraint imq_pk primary key  (imq01,imq02) enable validate;
grant select on imq_file to tiptopgp;
grant update on imq_file to tiptopgp;
grant delete on imq_file to tiptopgp;
grant insert on imq_file to tiptopgp;
grant index on imq_file to public;
grant select on imq_file to ods;
