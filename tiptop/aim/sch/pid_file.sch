/*
================================================================================
檔案代號:pid_file
檔案名稱:「在制工单」盘点标签档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pid_file
(
pid01       varchar2(20) NOT NULL,   /*标签编号                               */
                                     /*標籤編號                               */
                                     /*儲存該筆「在製工單」的對應盤點標籤號碼。*/
pid02       varchar2(20),            /*工单单号                               */
                                     /*工單單號                               */
                                     /*儲存該筆「在製工單」號碼。             */
pid021      number(5),               /*作业序号                               */
                                     /*作業序號 [ecm03]  99.12                */
pid022      varchar2(6),             /*作业编号                               */
                                     /*作業編號 [ecm04]  99.12                */
pid023      varchar2(10),            /*制造部门                               */
                                     /*製造部門  gem01   99.12                */
pid03       varchar2(40),            /*生产料件                               */
                                     /*生產料件                               */
                                     /*儲存該筆「在製工單」的生產料件。       */
pid04       number(15,3),            /*移转套数                               */
                                     /*移轉套數 99.12                         */
                                     /*原為:生產量                            */
                                     /*儲存該筆「在製工單」的生產量。         */
pid041      number(15,3),            /*初盘点(一) 移转套数                    */
                                     /*初盤點(一) 移轉套數 99.12              */
pid042      number(15,3),            /*初盘点(二) 移转套数                    */
                                     /*初盤點(二) 移轉套數 99.12              */
pid043      number(15,3),            /*复盘点(一) 移转套数                    */
                                     /*複盤點(一) 移轉套數 99.12              */
pid044      number(15,3),            /*复盘点(二) 移转套数                    */
                                     /*複盤點(二) 移轉套數 99.12              */
pid05       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
                                     /*儲存該筆「在製工單」的生產數量單位。   */
pid06       varchar2(1),             /*空白标签否                             */
                                     /*空白標籤否                             */
pid07       varchar2(1),             /*是否已作盘点资料「录入」               */
                                     /*是否已作盤點資料「輸入」               */
                                     /*儲存該筆「在製工單」盤點資料是否已被作 */
                                     /*「輸入」處理。                         */
                                     /*系統維護。                             */
pid08       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
                                     /*儲存該筆「在製工單」盤點資料產生者。   */
pid09       date,                    /*生成日期                               */
                                     /*產生日期                               */
                                     /*儲存該筆「在製工單」盤點資料產生日期。 */
pid10       date,                    /*修正日期                               */
                                     /*儲存該筆「在製工單」盤點資料再修正日期。*/
pid11       date,                    /*打印日期                               */
                                     /*列印日期                               */
                                     /*儲存該筆「在製工單」盤點資料最近一次被 */
                                     /*列印日期。                             */
pid12       number(5),               /*打印次数                               */
                                     /*列印次數                               */
                                     /*儲存該筆「在製工單」盤點資料共被列印次 */
                                     /*數。                                   */
pid13       number(15,3),            /*完工入库量                             */
                                     /*完工入庫量                             */
                                     /*儲存該筆「在製工單」的完工入庫量。     */
pid14       number(15,3),            /*返工量                                 */
                                     /*再加工量                               */
                                     /*儲存該筆「在製工單」的再加工量。       */
pid15       number(15,3),            /*完工全检量                             */
                                     /*完工全檢(FQC)量                        */
                                     /*儲存該筆「在製工單」的完工全檢(FQC)量。*/
pid16       number(15,3),            /*No Use                                 */
                                     /*no use (02/06/10 modify)               */
pid17       number(15,3),            /*报废量                                 */
                                     /*報廢量                                 */
                                     /*儲存該筆「在製工單」的報廢量。         */
pid18       varchar2(10),            /*备注制造部门                           */
                                     /*備註製造部門                           */
pid900      varchar2(4),             /*保税盘点位置                           */
                                     /*保稅盤點位置                           */
pid901      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pidplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pidlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pid012      varchar2(10),            /*工艺段号                               */
pid27       varchar2(40)             /*No Use                                 */
);

create        index pid_02 on pid_file (pid01,pid02,pid022);
alter table pid_file add  constraint pid_pk primary key  (pid01) enable validate;
grant select on pid_file to tiptopgp;
grant update on pid_file to tiptopgp;
grant delete on pid_file to tiptopgp;
grant insert on pid_file to tiptopgp;
grant index on pid_file to public;
grant select on pid_file to ods;
