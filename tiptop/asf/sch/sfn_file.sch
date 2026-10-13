/*
================================================================================
檔案代號:sfn_file
檔案名稱:工单变更明细纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfn_file
(
sfn01       varchar2(8) NOT NULL,    /*资料序号                               */
                                     /*資料序號 = sfm00                       */
sfn02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
sfn03       varchar2(20),            /*工单号码                               */
                                     /*工單號碼 (for sfm10='2')               */
                                     /*挪料型態 sfm10='2' 『單顆挪料』時      */
                                     /*此欄位紀錄 目的工單單號                */
sfn04       varchar2(40),            /*料号                                   */
                                     /*料號(if sfm10='2'                      */
                                     /*挪料型態 sfm10='2' 『單顆挪料』時      */
                                     /*此欄位紀錄 單筆移料之料號 同 sfm11     */
sfn05       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
sfn06       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
sfn07       number(15,3),            /*来源应退数量                           */
                                     /*來源應退數量                           */
                                     /*挪料型態 sfm10='1' 『整批挪料』時      */
                                     /*此欄位紀錄 來源工單應退數量            */
                                     /*挪料型態 sfm10='2' 『單顆挪料』時      */
                                     /*此欄位紀錄 應發數量(sfa05)             */
sfn08       number(15,3),            /*目的需求数量                           */
                                     /*目的需求數量                           */
                                     /*挪料型態 sfm10='1' 『整批挪料』時      */
                                     /*此欄位紀錄　目的工單需求數量           */
                                     /*挪料型態 sfm10='2' 『單顆挪料』時      */
                                     /*此欄位紀錄 已發數量(sfa05) '           */
sfn09       number(15,3),            /*入库数量                               */
                                     /*入庫數量(QPA*sfb09) (for sfm10='2')    */
                                     /*挪料型態 sfm10='2' 『單顆挪料』時      */
                                     /*此欄位紀錄 入庫數量                    */
sfn10       number(15,3),            /*移转数量                               */
                                     /*移轉數量                               */
sfn11       varchar2(1),             /*状况                                   */
                                     /*狀況 1:來源及目的工單共用材料(sfm10='1')*/
                                     /*     2:僅來源有此材料                  */
                                     /*     3:僅目的有此材料                  */
sfn12       varchar2(10),            /*仓库                                   */
                                     /*倉庫      #NO:6968                     */
sfn13       varchar2(10),            /*库位                                   */
                                     /*儲位      #NO:6968                     */
sfn14       varchar2(24),            /*批号                                   */
                                     /*批號      #NO:6968                     */
sfn15       number(15,3),            /*超领数量                               */
                                     /*超領數量  #NO:6968                     */
                                     /*挪料型態 sfm10='1' 『整批挪料』時      */
                                     /*此欄位紀錄 來源工單 的超領數量         */
sfnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sfn_file add  constraint sfn_pk primary key  (sfn01,sfn02) enable validate;
grant select on sfn_file to tiptopgp;
grant update on sfn_file to tiptopgp;
grant delete on sfn_file to tiptopgp;
grant insert on sfn_file to tiptopgp;
grant index on sfn_file to public;
grant select on sfn_file to ods;
