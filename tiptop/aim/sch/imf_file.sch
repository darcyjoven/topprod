/*
================================================================================
檔案代號:imf_file
檔案名稱:料件缺省仓库/存放位置资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imf_file
(
imf01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*Item#                                  */
                                     /*Supply User To Appoint Fixed Item Storage Place In WH/Location Mangement                            　　　*/
imf02       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*Warehouse#                             */
                                     /*Supply User To Appoint Fixed Item Storage Warehouse In WH/Location Mangement                            　　　*/
imf03       varchar2(10) NOT NULL,   /*存放位置                               */
                                     /*Location#                              */
                                     /*Supply User To Appoint Fixed Item Storage Location In WH/Location Mangement                            　　　*/
imf04       number(15,3),            /*最高存量限制                           */
                                     /*記錄儲存料件在此存放地點之最高存放數量 */
imf05       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
                                     /*儲存料件存在之倉儲庫存計量單位         */
imf06       number(5),               /*生产发料优先顺序                       */
                                     /*生產發料優先順序                       */
                                     /*於生產管理時可控制此倉庫發料優先順序   */
imf07       number(5)                /*销售领料优先顺序                       */
                                     /*銷售領料優先順序                       */
                                     /*於銷售管理時可控制此倉庫領料優先順序   */
);

alter table imf_file add  constraint imf_pk primary key  (imf01,imf02,imf03) enable validate;
grant select on imf_file to tiptopgp;
grant update on imf_file to tiptopgp;
grant delete on imf_file to tiptopgp;
grant insert on imf_file to tiptopgp;
grant index on imf_file to public;
grant select on imf_file to ods;
