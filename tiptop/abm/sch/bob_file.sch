/*
================================================================================
檔案代號:bob_file
檔案名稱:元件群组对替代群组关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bob_file
(
bob01       varchar2(40) NOT NULL,   /*上阶主件编号                           */
                                     /*上階主件編號                           */
                                     /*儲存可做SET替代的主件料號。            */
                                     /*主件料號需在料件基本資料主檔中。       */
bob02       number(5) NOT NULL,      /*元件群组                               */
                                     /*元件群組                               */
                                     /*儲存該上階組件可以做SET替代的組合群組  */
                                     /*序號                                   */
bob03       number(5) NOT NULL,      /*替代群组                               */
                                     /*替代群組                               */
                                     /*儲存該上階主件其元件群組可以做SET替代的*/
                                     /*替代群組序號                           */
bob04       varchar2(40) NOT NULL,   /*替代料件编号                           */
                                     /*替代料件編號                           */
                                     /*儲存該替代群組的替代料料號。           */
bob05       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
bob06       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*發料單位                               */
bob07       number(15,3),            /*替代量                                 */
                                     /*儲存元件群組對替代料群組的對應數量。   */
bob08       number(16,8),            /*组成用量                               */
                                     /*組成用量(QPA)                          */
                                     /*儲存該替代料號在該替代關係下的組合用量 */
                                     /*正確值 需 大於「0」。                  */
                                     /*預設值 「1」。                         */
bob09       number(16,8),            /*底数                                   */
                                     /*底數                                   */
                                     /*儲存該替代料號在該替代關係下的組合用量之*/
                                     /*基準主件量。                           */
                                     /*正確值 需 大於「0」。                  */
                                     /*慣性值 「1」。                         */
                                     /*真正的用量=組成用量/底數。             */
bob10       date,                    /*生效日期                               */
                                     /*儲存該替代元件SET替代的生效日期。      */
bob11       date,                    /*失效日期                               */
                                     /*儲存該替代元件SET替代的失效日期。      */
bob12       date,                    /*最近替代日                             */
                                     /*於工單發料作業過帳時自動更新           */
bob13       number(9,4),             /*容许误差比率                           */
                                     /*容許誤差比率                           */
bob14       varchar2(80)             /*说明                                   */
                                     /*說明                                   */
                                     /*此欄位為替代作業開窗選擇替代群組時的   */
                                     /*選提示項目                             */
);

alter table bob_file add  constraint bob_pk primary key  (bob01,bob02,bob03,bob04,bob05,bob06) enable validate;
grant select on bob_file to tiptopgp;
grant update on bob_file to tiptopgp;
grant delete on bob_file to tiptopgp;
grant insert on bob_file to tiptopgp;
grant index on bob_file to public;
grant select on bob_file to ods;
