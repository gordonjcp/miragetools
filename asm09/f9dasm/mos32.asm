f9dasm: M6800/M6809/H6309 Binary/OS9/FLEX9 Disassembler V1.61-RB
Loaded binary file mos32.bin

;****************************************************
;* Used Labels                                      *
;****************************************************

M0000                   	EQU	$0000
M0001                   	EQU	$0001
M0002                   	EQU	$0002
M0008                   	EQU	$0008
M004D                   	EQU	$004D
M00F0                   	EQU	$00F0
M0104                   	EQU	$0104
M0180                   	EQU	$0180
M0271                   	EQU	$0271
M038E                   	EQU	$038E
M03B1                   	EQU	$03B1
M03E8                   	EQU	$03E8
M03FA                   	EQU	$03FA
M0800                   	EQU	$0800
M0804                   	EQU	$0804
M0904                   	EQU	$0904
M1000                   	EQU	$1000
M1112                   	EQU	$1112
M1211                   	EQU	$1211
M181A                   	EQU	$181A
M1CEE                   	EQU	$1CEE
M2000                   	EQU	$2000
M2A1A                   	EQU	$2A1A
M2A3A                   	EQU	$2A3A
M2A7A                   	EQU	$2A7A
M2A8E                   	EQU	$2A8E
M2AB6                   	EQU	$2AB6
M387A                   	EQU	$387A
M3A7A                   	EQU	$3A7A
M4CC0                   	EQU	$4CC0
M7A9E                   	EQU	$7A9E
OSRAM_unused            	EQU	$B997
MC000                   	EQU	$C000
MCE7A                   	EQU	$CE7A
MD800                   	EQU	$D800
UART_csr                	EQU	$E100
UART_data               	EQU	$E101
VIA_dr_b                	EQU	$E200
VIA_dr_a                	EQU	$E201
VIA_t1c_lsb             	EQU	$E204
VIA_t1c_msb             	EQU	$E205
VIA_t1_lsb              	EQU	$E206
VIA_t2_msb              	EQU	$E207
VIA_shr                 	EQU	$E20A
VIA_aux                 	EQU	$E20B
VIA_pcr                 	EQU	$E20C
VIA_isr                 	EQU	$E20D
VIA_ier                 	EQU	$E20E
VIA_data                	EQU	$E20F
MUX_base                	EQU	$E418
VCF_base                	EQU	$E41F
ME420                   	EQU	$E420
FDC_track               	EQU	$E801
FDC_data                	EQU	$E803
DOC_control_base        	EQU	$EC5F
DOC_rts_base            	EQU	$EC7F
DOC_oir                 	EQU	$ECE0
DOC_oer                 	EQU	$ECE1
DOC_adc                 	EQU	$ECE2
ROM_fdcskipsector       	EQU	$F013
ROM_fdcfillsector       	EQU	$F037
ROM_fdcseekin           	EQU	$F07D
ROM_fdcseekout          	EQU	$F086
ROM_fdcforceinterrupt   	EQU	$F08F
ROM_countdown           	EQU	$F0A7
ROM_qchipsetup          	EQU	$F1BB
ROM_readsector          	EQU	$F448
ROM_writesector         	EQU	$F476
ROM_gototrack2          	EQU	$F4A4
ROM_enablefd            	EQU	$F4C6
ROM_disablefd           	EQU	$F4D6
ROM_timer2int           	EQU	$F4DF
ROM_unknown1            	EQU	$F514
ROM_unknown2            	EQU	$F52D
ROM_unknown3            	EQU	$F541
ROM_copybytes           	EQU	$F55B
ROM_tune_filters        	EQU	$F571
ROM_set_VCF_A_B         	EQU	$F5E7
ROM_set_DOC_freq_call_hdlrU	EQU	$F5F1
ROM_set_DOC_volume_call_hdlrD	EQU	$F6DD
ROM_8bit_exp            	EQU	$F77D
ROM_16bit_1exp          	EQU	$F7FD
ROM_8bit_sinpos_XX      	EQU	$F8CD
ROM_LED_hexnum          	EQU	$FB4D
ROM_keycode_xcode       	EQU	$FB68
ROM_ts_sysparam         	EQU	$FB88
ROM_ts_osflags          	EQU	$FB8C
ROM_ts_lower            	EQU	$FB90
ROM_ts_upper            	EQU	$FB9C
ROM_ts_shortseq         	EQU	$FBA8
ROM_ts_longseq          	EQU	$FBC8
ROM_unknown_fbd4        	EQU	$FBD4
ROM_unknown_fbdf        	EQU	$FBDF
ROM_bitmask_0to7        	EQU	$FBE2
ROM_bitmask_0to2        	EQU	$FBEA
ROM_unknown_fbed        	EQU	$FBED
ROM_unknown_fbf0        	EQU	$FBF0
ROM_8bit_atanh          	EQU	$FBF8
ROM_8bit_atanh_offs     	EQU	$FBFE
ROM_word_d15            	EQU	$FF10

;**************************************************
;* Program Code / Data Areas                      *
;**************************************************

        SETDP   $80

        ORG     $8000

; Ensoniq Mirage OS 3.2
M8000:	FCB     $88                      ;8000: 88 
M8001:	FCB     $09                      ;8001: 09 
M8002:	FCB     $0B                      ;8002: 0B 
M8003:	FCB     $05                      ;8003: 05 
M8004:	FCB     $00                      ;8004: 00 

word_8006_D:
        FCB     $00                      ;8005: 00 

word_8006_X:
        FCB     $00                      ;8006: 00 

word_8007_X:
        FCB     $00                      ;8007: 00 
;------------------------------------------------------------------------

SYS_irqvec:
        JMP     IRQ_entry                ;8008: 7E 89 3C 
;------------------------------------------------------------------------

SYS_firqvec:
        JMP     FIRQ_entry               ;800B: 7E A1 51 
;------------------------------------------------------------------------

SYS_osvec:
        JMP     osentry                  ;800E: 7E B9 20 
;------------------------------------------------------------------------

word_8011_X:
        FCB     $00                      ;8011: 00 

osparm_tuning:
        FCB     $32                      ;8012: 32 

osparm_bendrange:
        FCB     $02                      ;8013: 02 

osparm_velosens:
        FCB     $1E                      ;8014: 1E 

osparm_upperlower:
        FCB     $40                      ;8015: 40 

word_8016_X:
        FCB     $00                      ;8016: 00 

word_8017_X:
        FCB     $22                      ;8017: 22 

word_8018_X:
        FCB     $A0                      ;8018: A0 

word_8019_X:
        FCB     $00                      ;8019: 00 

word_801a_X:
        FCB     $30                      ;801A: 30 

word_801b_X:
        FCB     $00                      ;801B: 00 

word_801c_X:
        FCB     $01                      ;801C: 01 

word_801d_X:
        FCB     $01                      ;801D: 01 

word_801e_X:
        FCB     $01                      ;801E: 01 

word_801f_X:
        FCB     $7E                      ;801F: 7E 

word_8020_X:
        FCB     $01                      ;8020: 01 

MIDI_channel:
        FCB     $00                      ;8021: 00 

MIDI_thru_enabled:
        FCB     $00                      ;8022: 00 

word_8023_X:
        FCB     $02                      ;8023: 02 

word_8024_X:
        FCB     $00                      ;8024: 00 

word_8025_X:
        FCB     $00                      ;8025: 00 

word_8026_X:
        FCB     $60                      ;8026: 60 

word_8027_X:
        FCB     $01                      ;8027: 01 

word_8028_X:
        FCB     $00                      ;8028: 00 

word_8029_X:
        FCB     $00                      ;8029: 00 

word_802a_X:
        FCB     $00                      ;802A: 00 

word_802b_X:
        FCB     $32,$00,$00,$00          ;802B: 32 00 00 00 
M802F:	FCB     $00                      ;802F: 00 
M8030:	FCB     $00                      ;8030: 00 
M8031:	FCB     $00                      ;8031: 00 
M8032:	FCB     $00                      ;8032: 00 
M8033:	FCB     $00                      ;8033: 00 
M8034:	FCB     $00,$00                  ;8034: 00 00 
M8036:	FCB     $00                      ;8036: 00 
M8037:	FCB     $00                      ;8037: 00 

flag_8038_0_marks_empty_8059_task:
        FCB     $00                      ;8038: 00 

vector_8039_U:
        FDB     M0000                    ;8039: 00 00 

vector_803b_U:
        FDB     M0000                    ;803B: 00 00 

vector_803d_U:
        FDB     M0000                    ;803D: 00 00 

vector_803f_U:
        FDB     M0000                    ;803F: 00 00 

vector_8041_U:
        FDB     M0000                    ;8041: 00 00 

vector_8043_U:
        FDB     M0000                    ;8043: 00 00 
M8045:	FCB     $00,$00                  ;8045: 00 00 
M8047:	FCB     $00                      ;8047: 00 
M8048:	FCB     $00                      ;8048: 00 
M8049:	FCB     $00,$00                  ;8049: 00 00 
M804B:	FCB     $00,$00,$00              ;804B: 00 00 00 

flag_804e_0_disables_call_8059_task:
        FCB     $00                      ;804E: 00 

table_base_804f:
        FDB     M0000                    ;804F: 00 00 
        FCB     $00,$00,$00,$00,$00      ;8051: 00 00 00 00 00 

vector_8056_U:
        FDB     M0000                    ;8056: 00 00 
        FCB     $00                      ;8058: 00 

task_vector_8059:
        FDB     M0000                    ;8059: 00 00 

task_vector_805b:
        FDB     M0000                    ;805B: 00 00 

kbd_msg_byte_count:
        FCB     $00                      ;805D: 00 

context_ptr:
        FDB     context_storage          ;805E: B2 BE 

DOC_irq_cnt:
        FCB     $00                      ;8060: 00 

kbd_parser_ptr:
        FDB     M0000                    ;8061: 00 00 

kbd_normalized_note:
        FCB     $00                      ;8063: 00 
M8064:	FCB     $00                      ;8064: 00 
M8065:	FCB     $FF                      ;8065: FF 
M8066:	FCB     $FF                      ;8066: FF 
M8067:	FCB     $FF                      ;8067: FF 

val_modwheel:
        FCB     $00                      ;8068: 00 

val_pitchwheel:
        FCB     $00                      ;8069: 00 

val_pitchwheel_related:
        FCB     $00                      ;806A: 00 

kbd_flag_damper_pedal_onoff:
        FCB     $00                      ;806B: 00 

val_modwheel_related:
        FCB     $00,$00,$32              ;806C: 00 00 32 

vector_806f_X:
        FCB     $00                      ;806F: 00 
M8070:	FCB     $00,$00                  ;8070: 00 00 
M8072:	FCB     $00                      ;8072: 00 
M8073:	FCB     $00,$00,$32              ;8073: 00 00 32 

vector_8076_X:
        FCB     $00                      ;8076: 00 
M8077:	FCB     $00,$00                  ;8077: 00 00 

kdb_pedal_state_40:
        FCB     $00                      ;8079: 00 
M807A:	FCB     $00,$00,$32              ;807A: 00 00 32 
M807D:	FCB     $3F                      ;807D: 3F 
M807E:	FCB     $FF                      ;807E: FF 
M807F:	FCB     $FF                      ;807F: FF 
M8080:	FCB     $00                      ;8080: 00 
M8081:	FCB     $00                      ;8081: 00 
M8082:	FCB     $00                      ;8082: 00 
M8083:	FCB     $00                      ;8083: 00 
M8084:	FCB     $00                      ;8084: 00 
M8085:	FCB     $00,$00                  ;8085: 00 00 
M8087:	FCB     $00                      ;8087: 00 
M8088:	FCB     $00                      ;8088: 00 
M8089:	FCB     $00                      ;8089: 00 
M808A:	FCB     $00                      ;808A: 00 
M808B:	FCB     $15                      ;808B: 15 
M808C:	FCB     $01                      ;808C: 01 
M808D:	FCB     $00                      ;808D: 00 
M808E:	FCB     $00                      ;808E: 00 
M808F:	FCB     $00                      ;808F: 00 
M8090:	FCB     $00                      ;8090: 00 
M8091:	FCB     $00                      ;8091: 00 
M8092:	FCB     $00                      ;8092: 00 
M8093:	FCB     $00                      ;8093: 00 
M8094:	FCB     $00,$00                  ;8094: 00 00 
M8096:	FCB     $00,$F0                  ;8096: 00 F0 
M8098:	FCB     $00                      ;8098: 00 
M8099:	FCB     $00                      ;8099: 00 
M809A:	FCB     $00                      ;809A: 00 
M809B:	FCB     $00                      ;809B: 00 
M809C:	FCB     $00                      ;809C: 00 
M809D:	FCB     $00,$00                  ;809D: 00 00 

809f_via_X:
        FCB     $00                      ;809F: 00 
M80A0:	FCB     $00                      ;80A0: 00 
M80A1:	FCB     $00                      ;80A1: 00 
M80A2:	FCB     $00                      ;80A2: 00 
M80A3:	FCB     $00                      ;80A3: 00 
M80A4:	FCB     $00                      ;80A4: 00 

vec_80a5:
        FDB     tab_b76f_step36          ;80A5: B7 6F 

vec_80a7:
        FDB     tab_b4fe_step36          ;80A7: B4 FE 

vector_80a9_X:
        FDB     M0000                    ;80A9: 00 00 
M80AB:	FDB     M0000                    ;80AB: 00 00 
M80AD:	FCB     $11                      ;80AD: 11 
M80AE:	FCB     $0B                      ;80AE: 0B 
M80AF:	FCB     $F0                      ;80AF: F0 
M80B0:	FCB     $0F                      ;80B0: 0F 
M80B1:	FCB     $0F                      ;80B1: 0F 
M80B2:	FCB     $00                      ;80B2: 00 
M80B3:	FCB     $DA                      ;80B3: DA 
M80B4:	FCB     $60                      ;80B4: 60 
M80B5:	FCB     $00                      ;80B5: 00 
M80B6:	FCB     $00                      ;80B6: 00 
M80B7:	FCB     $00                      ;80B7: 00 
M80B8:	FCB     $00,$00                  ;80B8: 00 00 
M80BA:	FCB     $00                      ;80BA: 00 

MIDI_cmd:
        FCB     $00                      ;80BB: 00 

MIDI_txbuf_msg_start:
        FDB     MIDI_txbuf_base          ;80BC: 82 25 

MIDI_txbuf_msg_end:
        FDB     MIDI_txbuf_base          ;80BE: 82 25 

ptr_UART_rxhdlr:
        FDB     UART_rx_parser_exit      ;80C0: A2 4A 

MIDI_txcmd_params:
        FCB     $00                      ;80C2: 00 

MIDI_txcmd_param2:
        FCB     $00                      ;80C3: 00 

MIDI_rxcmd_channel:
        FCB     $00                      ;80C4: 00 

MIDI_rxcmd:
        FCB     $00                      ;80C5: 00 

ptr_UART_txhdlr:
        FDB     UART_txhdlr              ;80C6: A1 BC 
        FCB     $00,$00,$00,$00,$00      ;80C8: 00 00 00 00 00 
M80CD:	FCB     $00                      ;80CD: 00 
M80CE:	FCB     $00                      ;80CE: 00 

MIDI_program_number:
        FCB     $FF                      ;80CF: FF 
M80D0:	FCB     $FF                      ;80D0: FF 
M80D1:	FCB     $FF                      ;80D1: FF 

vector_80d2_X:
        FCB     $FF                      ;80D2: FF 
M80D3:	FCB     $FF                      ;80D3: FF 
M80D4:	FCB     $FF                      ;80D4: FF 

disk_first_trk:
        FCB     $FF                      ;80D5: FF 

disk_first_sec:
        FCB     $FF                      ;80D6: FF 

disk_last_trk:
        FCB     $FF                      ;80D7: FF 

disk_last_sec:
        FCB     $FF,$FF,$FF              ;80D8: FF FF FF 
M80DB:	FCB     $FF,$FF                  ;80DB: FF FF 
M80DD:	FCB     $FF                      ;80DD: FF 
M80DE:	FCB     $FF,$FF                  ;80DE: FF FF 
M80E0:	FCB     $FF                      ;80E0: FF 
M80E1:	FCB     $FF                      ;80E1: FF 
M80E2:	FCB     $FF                      ;80E2: FF 
M80E3:	FCB     $FF                      ;80E3: FF 
M80E4:	FCB     $00                      ;80E4: 00 
M80E5:	FCB     $C0,$00                  ;80E5: C0 00 
M80E7:	FCB     $00                      ;80E7: 00 
M80E8:	FCB     $FF                      ;80E8: FF 
M80E9:	FCB     $FF                      ;80E9: FF 
M80EA:	FCB     $FF                      ;80EA: FF 
M80EB:	FCB     $01                      ;80EB: 01 
M80EC:	FDB     ptr_b80a                 ;80EC: B8 0A 
M80EE:	FDB     word_via_80ee            ;80EE: AB 2A 
M80F0:	FCB     $FF                      ;80F0: FF 
M80F1:	FCB     $FF                      ;80F1: FF 
M80F2:	FCB     $FF                      ;80F2: FF 
M80F3:	FCB     $FF                      ;80F3: FF 

tab_setbit_0to7:
        FCB     $01,$02,$04,$08,$10,$20  ;80F4: 01 02 04 08 10 20 
        FCB     $40,$80                  ;80FA: 40 80 

tab_clrbit_0to7:
        FCB     $FE,$FD,$FB,$F7,$EF,$DF  ;80FC: FE FD FB F7 EF DF 
        FCB     $BF,$7F                  ;8102: BF 7F 
M8104:	FCB     $00                      ;8104: 00 
M8105:	FCB     $00                      ;8105: 00 
M8106:	FCB     $00                      ;8106: 00 

field_248_bytes_8107_via_D:
        FCB     $00,$00,$00,$00,$00,$00  ;8107: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;810D: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8113: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8119: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;811F: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8125: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;812B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8131: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8137: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$FF,$FF,$FF  ;813D: 00 00 00 FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8143: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8149: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;814F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8155: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;815B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8161: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8167: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;816D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8173: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8179: FF FF FF FF FF FF 
        FCB     $FF,$00,$00,$00,$00,$00  ;817F: FF 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8185: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;818B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8191: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8197: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;819D: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;81A3: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;81A9: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;81AF: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;81B5: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$FF  ;81BB: 00 00 00 00 00 FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81C1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81C7: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81CD: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81D3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81D9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81DF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81E5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81EB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81F1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;81F7: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;81FD: FF FF 
M81FF:	FCB     $00,$00,$00,$00,$00,$00  ;81FF: 00 00 00 00 00 00 
        FCB     $00,$00                  ;8205: 00 00 
M8207:	FCB     $01                      ;8207: 01 
M8208:	FCB     $00                      ;8208: 00 

table_10_20_00:
        FCB     $10,$20,$00              ;8209: 10 20 00 

table_02_00_01:
        FCB     $02,$00,$01              ;820C: 02 00 01 

table_04_08_0c|05_09_0d|06_0a_0e|07_0b_0f|80_81_82_83:
        FCB     $04,$08,$0C,$05,$09,$0D  ;820F: 04 08 0C 05 09 0D 
        FCB     $06,$0A,$0E,$07,$0B,$0F  ;8215: 06 0A 0E 07 0B 0F 
        FCB     $80,$81,$82,$83          ;821B: 80 81 82 83 
M821F:	FCB     $00                      ;821F: 00 
M8220:	FCB     $00,$00                  ;8220: 00 00 
M8222:	FCB     $08                      ;8222: 08 
M8223:	FCB     $03,$00                  ;8223: 03 00 

MIDI_txbuf_base:
        FCB     $00,$00,$00,$00,$00,$00  ;8225: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;822B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00          ;8231: 00 00 00 00 

MIDI_txbuf_len:
        FCB     $00                      ;8235: 00 

MIDI_rxbuf_len:
        FCB     $00                      ;8236: 00 

MIDI_rx_pending:
        FCB     $00                      ;8237: 00 

MIDI_rxbuf_base:
        FCB     $00,$00,$00,$00,$00,$00  ;8238: 00 00 00 00 00 00 
        FCB     $00,$00,$FF,$FF,$FF,$FF  ;823E: 00 00 FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8244: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;824A: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8250: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8256: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;825C: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8262: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;8268: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;826E: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF          ;8274: FF FF FF FF 

vec_to_8280_seemingly_static:
        FDB     data_via_8278_static_zero_changed_relative? ;8278: 82 80 

vec_to_827c_seemingly_static:
        FDB     table_10_11_01_0a        ;827A: 82 7C 

table_10_11_01_0a:
        FCB     $10,$11,$01,$0A          ;827C: 10 11 01 0A 

data_via_8278_static_zero_changed_relative?:
        FCB     $00,$00,$00,$00,$00,$00  ;8280: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8286: 00 00 00 00 00 00 
;------------------------------------------------------------------------
Z828C:	PSHS    CC                       ;828C: 34 01 
        CLR     flag_804e_0_disables_call_8059_task ;828E: 0F 4E 
Z8290:	ORCC    #$50                     ;8290: 1A 50 
        LDA     flag_804e_0_disables_call_8059_task ;8292: 96 4E 
        BNE     Z829D                    ;8294: 26 07 
        LDY     task_vector_8059         ;8296: 10 9E 59 
        BNE     Z829F                    ;8299: 26 04 
        CLR     flag_8038_0_marks_empty_8059_task ;829B: 0F 38 
Z829D:	PULS    PC,CC                    ;829D: 35 81 
;------------------------------------------------------------------------
Z829F:	LDD     ,Y                       ;829F: EC A4 
        STD     task_vector_8059         ;82A1: DD 59 
        BNE     Z82A7                    ;82A3: 26 02 
        STD     task_vector_805b         ;82A5: DD 5B 
Z82A7:	ANDCC   #$AF                     ;82A7: 1C AF 
        JSR     [$02,Y]                  ;82A9: AD B8 02 
        BRA     Z8290                    ;82AC: 20 E2 
;------------------------------------------------------------------------

code_82ae_via_U:
        LDB     $04,Y                    ;82AE: E6 24 
        SUBB    #$24                     ;82B0: C0 24 
        LDU     #table_base_804f         ;82B2: CE 80 4F 
        TFR     B,A                      ;82B5: 1F 98 
        LSRA                             ;82B7: 44 
        LSRA                             ;82B8: 44 
        LSRA                             ;82B9: 44 
        ANDB    #$07                     ;82BA: C4 07 
        LDX     #tab_clrbit_0to7         ;82BC: 8E 80 FC 
        LDB     B,X                      ;82BF: E6 85 
        ANDB    A,U                      ;82C1: E4 C6 
        STB     A,U                      ;82C3: E7 C6 
        LDA     $05,Y                    ;82C5: A6 25 
        STA     flag_804e_copy_of_+05,Y  ;82C7: 97 4D 
        LDB     $04,Y                    ;82C9: E6 24 
        LDA     $07,Y                    ;82CB: A6 27 
        JSR     Z8738                    ;82CD: BD 87 38 
        LDX     M8045                    ;82D0: 9E 45 
        BEQ     Z82F5                    ;82D2: 27 21 
        CMPB    M807D                    ;82D4: D1 7D 
        BCS     Z82F5                    ;82D6: 25 1D 
        STA     $05,X                    ;82D8: A7 05 
        STB     $06,X                    ;82DA: E7 06 
        LDA     M807D                    ;82DC: 96 7D 
        SUBA    #$24                     ;82DE: 80 24 
        PSHS    A                        ;82E0: 34 02 
        BSR     Z834C                    ;82E2: 8D 68 
        LDA     #$FF                     ;82E4: 86 FF 
        STA     M8106                    ;82E6: B7 81 06 
        BCC     Z833D                    ;82E9: 24 52 
        ADDB    #$24                     ;82EB: CB 24 
        STB     $06,X                    ;82ED: E7 06 
        STB     M8106                    ;82EF: F7 81 06 
        JMP     Z8423                    ;82F2: 7E 84 23 
;------------------------------------------------------------------------
Z82F5:	LDX     M8047                    ;82F5: 9E 47 
        BEQ     Z831A                    ;82F7: 27 21 
        CMPB    M807D                    ;82F9: D1 7D 
        BCC     Z831A                    ;82FB: 24 1D 
        STA     $05,X                    ;82FD: A7 05 
        STB     $06,X                    ;82FF: E7 06 
        CLR     ,-S                      ;8301: 6F E2 
        BSR     Z834C                    ;8303: 8D 47 
        LDA     #$FF                     ;8305: 86 FF 
        STA     M8105                    ;8307: B7 81 05 
        BCC     Z833D                    ;830A: 24 31 
        ADDB    #$24                     ;830C: CB 24 
        CMPB    M807D                    ;830E: D1 7D 
        BCC     Z833D                    ;8310: 24 2B 
        STB     $06,X                    ;8312: E7 06 
        STB     M8105                    ;8314: F7 81 05 
        JMP     Z8423                    ;8317: 7E 84 23 
;------------------------------------------------------------------------
Z831A:	LDX     vector_803d_U            ;831A: 9E 3D 
Z831C:	BEQ     Z834B                    ;831C: 27 2D 
        CMPD    $05,X                    ;831E: 10 A3 05 
        BNE     Z8347                    ;8321: 26 24 
        LDB     flag_804e_copy_of_+05,Y  ;8323: D6 4D 
        STB     $09,X                    ;8325: E7 09 
        LDU     #vector_803d_U           ;8327: CE 80 3D 
        JSR     Z86F6                    ;832A: BD 86 F6 
        LDU     #vector_8043_U           ;832D: CE 80 43 
        JSR     Z8722                    ;8330: BD 87 22 
        LDA     #$41                     ;8333: 86 41 
        STA     $07,X                    ;8335: A7 07 
        LDU     $04,X                    ;8337: EE 04 
        LDA     $03,U                    ;8339: A6 43 
        BNE     Z8346                    ;833B: 26 09 
Z833D:	LDA     #$40                     ;833D: 86 40 
        STA     $07,X                    ;833F: A7 07 
        TFR     X,Y                      ;8341: 1F 12 
        JSR     Z8E05                    ;8343: BD 8E 05 
Z8346:	RTS                              ;8346: 39 
;------------------------------------------------------------------------
Z8347:	LDX     ,X                       ;8347: AE 84 
        BRA     Z831C                    ;8349: 20 D1 
;------------------------------------------------------------------------
Z834B:	RTS                              ;834B: 39 
;------------------------------------------------------------------------
Z834C:	LDU     #table_base_804f         ;834C: CE 80 4F 
        CLRA                             ;834F: 4F 
        CLRB                             ;8350: 5F 
Z8351:	LDA     ,U+                      ;8351: A6 C0 
        BNE     Z8363                    ;8353: 26 0E 
        ADDB    #$08                     ;8355: CB 08 
Z8357:	CMPB    #$40                     ;8357: C1 40 
        BNE     Z8351                    ;8359: 26 F6 
        LDU     ,S                       ;835B: EE E4 
        LEAS    $03,S                    ;835D: 32 63 
        ANDCC   #$FE                     ;835F: 1C FE 
        JMP     ,U                       ;8361: 6E C4 
;------------------------------------------------------------------------
Z8363:	PSHS    A                        ;8363: 34 02 
        CLRA                             ;8365: 4F 
Z8366:	ASR     ,S                       ;8366: 67 E4 
        BCC     Z8376                    ;8368: 24 0C 
        CMPB    $03,S                    ;836A: E1 63 
        BCS     Z8376                    ;836C: 25 08 
        LDU     $01,S                    ;836E: EE 61 
        LEAS    $04,S                    ;8370: 32 64 
        ORCC    #$01                     ;8372: 1A 01 
        JMP     ,U                       ;8374: 6E C4 
;------------------------------------------------------------------------
Z8376:	INCB                             ;8376: 5C 
        INCA                             ;8377: 4C 
        CMPA    #$08                     ;8378: 81 08 
        BNE     Z8366                    ;837A: 26 EA 
        LEAS    $01,S                    ;837C: 32 61 
        BRA     Z8357                    ;837E: 20 D7 
;------------------------------------------------------------------------

code_8380_via_U:
        LDB     $04,Y                    ;8380: E6 24 
        SUBB    #$24                     ;8382: C0 24 
        LDU     #table_base_804f         ;8384: CE 80 4F 
        TFR     B,A                      ;8387: 1F 98 
        LSRA                             ;8389: 44 
        LSRA                             ;838A: 44 
        LSRA                             ;838B: 44 
        ANDB    #$07                     ;838C: C4 07 
        LDX     #tab_setbit_0to7         ;838E: 8E 80 F4 
        LDB     B,X                      ;8391: E6 85 
        ORB     A,U                      ;8393: EA C6 
        STB     A,U                      ;8395: E7 C6 
        LDB     $04,Y                    ;8397: E6 24 
        CMPB    M807D                    ;8399: D1 7D 
        BCS     Z83BD                    ;839B: 25 20 
        LDA     [vec_80a5]               ;839D: A6 9F 80 A5 
        BEQ     Z83BB                    ;83A1: 27 18 
        CMPB    M8106                    ;83A3: F1 81 06 
        BCS     Z83AC                    ;83A6: 25 04 
        JSR     Z8738                    ;83A8: BD 87 38 
        RTS                              ;83AB: 39 
;------------------------------------------------------------------------
Z83AC:	STB     M8106                    ;83AC: F7 81 06 
        LDA     #$01                     ;83AF: 86 01 
        STA     M8104                    ;83B1: B7 81 04 
        LDX     M8045                    ;83B4: 9E 45 
        BEQ     Z83EF                    ;83B6: 27 37 
        JMP     Z841B                    ;83B8: 7E 84 1B 
;------------------------------------------------------------------------
Z83BB:	BRA     Z83DB                    ;83BB: 20 1E 
;------------------------------------------------------------------------
Z83BD:	LDA     [vec_80a7]               ;83BD: A6 9F 80 A7 
        BEQ     Z83DB                    ;83C1: 27 18 
        CMPB    M8105                    ;83C3: F1 81 05 
        BCS     Z83CC                    ;83C6: 25 04 
        JSR     Z8738                    ;83C8: BD 87 38 
        RTS                              ;83CB: 39 
;------------------------------------------------------------------------
Z83CC:	STB     M8105                    ;83CC: F7 81 05 
        LDA     #$02                     ;83CF: 86 02 
        STA     M8104                    ;83D1: B7 81 04 
        LDX     M8047                    ;83D4: 9E 47 
        BEQ     Z83EF                    ;83D6: 27 17 
        JMP     Z841B                    ;83D8: 7E 84 1B 
;------------------------------------------------------------------------
Z83DB:	CLR     M8104                    ;83DB: 7F 81 04 
        LDA     $07,Y                    ;83DE: A6 27 
        LDX     vector_8041_U            ;83E0: 9E 41 
Z83E2:	BEQ     Z83EF                    ;83E2: 27 0B 
        CMPD    $05,X                    ;83E4: 10 A3 05 
        BNE     Z83EB                    ;83E7: 26 02 
        BRA     Z8403                    ;83E9: 20 18 
;------------------------------------------------------------------------
Z83EB:	LDX     ,X                       ;83EB: AE 84 
        BRA     Z83E2                    ;83ED: 20 F3 
;------------------------------------------------------------------------
Z83EF:	LDX     vector_8039_U            ;83EF: 9E 39 
        BEQ     Z83FF                    ;83F1: 27 0C 
        JSR     Z8432                    ;83F3: BD 84 32 
        LDU     #vector_8039_U           ;83F6: CE 80 39 
        JSR     Z86F6                    ;83F9: BD 86 F6 
        JMP     Z8443                    ;83FC: 7E 84 43 
;------------------------------------------------------------------------
Z83FF:	LDX     vector_8041_U            ;83FF: 9E 41 
        BEQ     Z840D                    ;8401: 27 0A 
Z8403:	BSR     Z8432                    ;8403: 8D 2D 
        LDU     #vector_8041_U           ;8405: CE 80 41 
        JSR     Z86F6                    ;8408: BD 86 F6 
        BRA     Z8443                    ;840B: 20 36 
;------------------------------------------------------------------------
Z840D:	LDX     vector_803d_U            ;840D: 9E 3D 
Z840F:	BEQ     Z840F                    ;840F: 27 FE 
        BSR     Z8432                    ;8411: 8D 1F 
        LDU     #vector_803d_U           ;8413: CE 80 3D 
        JSR     Z86F6                    ;8416: BD 86 F6 
        BRA     Z8443                    ;8419: 20 28 
;------------------------------------------------------------------------
Z841B:	BEQ     Z842F                    ;841B: 27 12 
        BSR     Z8432                    ;841D: 8D 13 
        LDA     $07,X                    ;841F: A6 07 
        BPL     Z842D                    ;8421: 2A 0A 
Z8423:	LDU     $0C,X                    ;8423: EE 0C 
        TFR     X,Y                      ;8425: 1F 12 
        JSR     Z8BCD                    ;8427: BD 8B CD 
        JMP     Z8C34                    ;842A: 7E 8C 34 
;------------------------------------------------------------------------
Z842D:	BRA     Z8460                    ;842D: 20 31 
;------------------------------------------------------------------------
Z842F:	JMP     Z83EF                    ;842F: 7E 83 EF 
;------------------------------------------------------------------------
Z8432:	LDD     $04,Y                    ;8432: EC 24 
        STA     $06,X                    ;8434: A7 06 
        STB     $08,X                    ;8436: E7 08 
        LDA     $07,Y                    ;8438: A6 27 
        STA     $05,X                    ;843A: A7 05 
        CLR     $18,X                    ;843C: 6F 88 18 
        JSR     Z8738                    ;843F: BD 87 38 
        RTS                              ;8442: 39 
;------------------------------------------------------------------------
Z8443:	LDA     M8104                    ;8443: B6 81 04 
        CMPA    #$00                     ;8446: 81 00 
        BNE     Z8452                    ;8448: 26 08 
        LDU     #vector_803f_U           ;844A: CE 80 3F 
        JSR     Z8722                    ;844D: BD 87 22 
        BRA     Z8460                    ;8450: 20 0E 
;------------------------------------------------------------------------
Z8452:	CMPA    #$01                     ;8452: 81 01 
        BNE     Z845A                    ;8454: 26 04 
        STX     M8045                    ;8456: 9F 45 
        BRA     Z8460                    ;8458: 20 06 
;------------------------------------------------------------------------
Z845A:	CMPA    #$02                     ;845A: 81 02 
        BNE     Z8460                    ;845C: 26 02 
        STX     M8047                    ;845E: 9F 47 
Z8460:	LDA     #$80                     ;8460: 86 80 
        STA     $07,X                    ;8462: A7 07 
        TFR     X,Y                      ;8464: 1F 12 
        JSR     Z8E45                    ;8466: BD 8E 45 
        JSR     Z8D03                    ;8469: BD 8D 03 
        LDU     $0C,Y                    ;846C: EE 2C 
        JSR     Z8BCD                    ;846E: BD 8B CD 
        LDU     $0C,Y                    ;8471: EE 2C 
        LDX     $0E,Y                    ;8473: AE 2E 
        ORCC    #$10                     ;8475: 1A 10 
        LDA     #$03                     ;8477: 86 03 
        ORA     $41,Y                    ;8479: AA A8 41 
        STA     $21,X                    ;847C: A7 88 21 
        STA     $22,X                    ;847F: A7 88 22 
        LDA     #$03                     ;8482: 86 03 
        ORA     $4C,Y                    ;8484: AA A8 4C 
        STA     $23,X                    ;8487: A7 88 23 
        STA     $24,X                    ;848A: A7 88 24 
        CLR     $17,Y                    ;848D: 6F A8 17 
        PSHS    X                        ;8490: 34 10 
        JSR     Z8C34                    ;8492: BD 8C 34 
        LDU     $0C,Y                    ;8495: EE 2C 
        LDX     $0E,Y                    ;8497: AE 2E 
        JSR     Z8A78                    ;8499: BD 8A 78 
        ORCC    #$10                     ;849C: 1A 10 
        INC     $19,Y                    ;849E: 6C A8 19 
        LEAY    $37,Y                    ;84A1: 31 A8 37 
        BSR     Z84C5                    ;84A4: 8D 1F 
        LEAS    $02,S                    ;84A6: 32 62 
        LEAY    -$37,Y                   ;84A8: 31 A8 C9 
        LDX     $0A,Y                    ;84AB: AE 2A 
        LDA     $0B,X                    ;84AD: A6 0B 
        BEQ     Z84B4                    ;84AF: 27 03 
        LEAU    $18,U                    ;84B1: 33 C8 18 
Z84B4:	LDD     $0E,Y                    ;84B4: EC 2E 
        ADDD    #M0002                   ;84B6: C3 00 02 
        PSHS    D                        ;84B9: 34 06 
        LEAY    $42,Y                    ;84BB: 31 A8 42 
        BSR     Z84C5                    ;84BE: 8D 05 
        LEAS    $02,S                    ;84C0: 32 62 
        ANDCC   #$AF                     ;84C2: 1C AF 
        RTS                              ;84C4: 39 
;------------------------------------------------------------------------
Z84C5:	LDX     ,U                       ;84C5: AE C4 
        LDD     ,X++                     ;84C7: EC 81 
        STD     M8049                    ;84C9: DD 49 
        LDD     ,X++                     ;84CB: EC 81 
        STD     M804B                    ;84CD: DD 4B 
        STX     $02,Y                    ;84CF: AF 22 
        LDX     $02,S                    ;84D1: AE 62 
        LDD     M8049                    ;84D3: DC 49 
        CLR     -$3F,X                   ;84D5: 6F 88 C1 
        CLR     -$3E,X                   ;84D8: 6F 88 C2 
        STA     $01,X                    ;84DB: A7 01 
        STB     $41,X                    ;84DD: E7 88 41 
        LDD     M804B                    ;84E0: DC 4B 
        STA     $02,X                    ;84E2: A7 02 
        STB     $42,X                    ;84E4: E7 88 42 
        LDD     $04,U                    ;84E7: EC 44 
        STD     $04,Y                    ;84E9: ED 24 
        LDD     $06,U                    ;84EB: EC 46 
        STD     $06,Y                    ;84ED: ED 26 
        LDD     $02,U                    ;84EF: EC 42 
        STD     $08,Y                    ;84F1: ED 28 
        LDA     $08,U                    ;84F3: A6 48 
        BEQ     Z853E                    ;84F5: 27 47 
        LDA     $14,U                    ;84F7: A6 C8 14 
        BEQ     Z8501                    ;84FA: 27 05 
        LDD     #code_88a6_via_D         ;84FC: CC 88 A6 
        BRA     Z8504                    ;84FF: 20 03 
;------------------------------------------------------------------------
Z8501:	LDD     #code_8894_via_D         ;8501: CC 88 94 
Z8504:	STD     ,Y                       ;8504: ED A4 
        LDD     $02,Y                    ;8506: EC 22 
        CMPD    $02,U                    ;8508: 10 A3 42 
        BCS     Z8520                    ;850B: 25 13 
        LDD     $04,U                    ;850D: EC 44 
        STD     $02,Y                    ;850F: ED 22 
        LDD     $02,U                    ;8511: EC 42 
        SUBD    ,U                       ;8513: A3 C4 
        CMPB    #$02                     ;8515: C1 02 
        BNE     Z8520                    ;8517: 26 07 
        LDD     M8049                    ;8519: DC 49 
        STA     $02,X                    ;851B: A7 02 
        STB     $42,X                    ;851D: E7 88 42 
Z8520:	LDA     $14,U                    ;8520: A6 C8 14 
        BEQ     Z8530                    ;8523: 27 0B 
        LDD     $04,U                    ;8525: EC 44 
        CMPD    ,U                       ;8527: 10 A3 C4 
        BNE     Z8530                    ;852A: 26 04 
        LDA     #$01                     ;852C: 86 01 
        BRA     Z8532                    ;852E: 20 02 
;------------------------------------------------------------------------
Z8530:	LDA     #$0F                     ;8530: 86 0F 
Z8532:	ORA     $0A,Y                    ;8532: AA 2A 
        STA     $22,X                    ;8534: A7 88 22 
        ANDA    #$FE                     ;8537: 84 FE 
        STA     $21,X                    ;8539: A7 88 21 
        BRA     Z857E                    ;853C: 20 40 
;------------------------------------------------------------------------
Z853E:	LDD     $02,U                    ;853E: EC 42 
        SUBD    ,U                       ;8540: A3 C4 
        CMPB    #$02                     ;8542: C1 02 
        BNE     Z8554                    ;8544: 26 0E 
        LDD     #code_88e3_via_D         ;8546: CC 88 E3 
        STD     ,Y                       ;8549: ED A4 
        LDA     #$0A                     ;854B: 86 0A 
        ORA     $0A,Y                    ;854D: AA 2A 
        STA     $21,X                    ;854F: A7 88 21 
        BRA     Z857E                    ;8552: 20 2A 
;------------------------------------------------------------------------
Z8554:	CMPB    #$04                     ;8554: C1 04 
        BNE     Z856D                    ;8556: 26 15 
        LDD     #code_88de_via_D         ;8558: CC 88 DE 
        STD     ,Y                       ;855B: ED A4 
        LDA     #$0B                     ;855D: 86 0B 
        ORA     $0A,Y                    ;855F: AA 2A 
        STA     $22,X                    ;8561: A7 88 22 
        LDA     #$0E                     ;8564: 86 0E 
        ORA     $0A,Y                    ;8566: AA 2A 
        STA     $21,X                    ;8568: A7 88 21 
        BRA     Z857E                    ;856B: 20 11 
;------------------------------------------------------------------------
Z856D:	LDD     #code_88c2_via_D         ;856D: CC 88 C2 
        STD     ,Y                       ;8570: ED A4 
        LDA     #$0F                     ;8572: 86 0F 
        ORA     $0A,Y                    ;8574: AA 2A 
        STA     $22,X                    ;8576: A7 88 22 
        ANDA    #$FE                     ;8579: 84 FE 
        STA     $21,X                    ;857B: A7 88 21 
Z857E:	RTS                              ;857E: 39 
;------------------------------------------------------------------------

code_857f_via_U:
        LDA     $07,Y                    ;857F: A6 27 
        LDB     $04,Y                    ;8581: E6 24 
        LDX     vector_803d_U            ;8583: 9E 3D 
Z8585:	BEQ     Z8597                    ;8585: 27 10 
        CMPD    $05,X                    ;8587: 10 A3 05 
        BNE     Z8593                    ;858A: 26 07 
        LDA     $05,Y                    ;858C: A6 25 
        STA     $18,X                    ;858E: A7 88 18 
        BRA     Z85B5                    ;8591: 20 22 
;------------------------------------------------------------------------
Z8593:	LDX     ,X                       ;8593: AE 84 
        BRA     Z8585                    ;8595: 20 EE 
;------------------------------------------------------------------------
Z8597:	LDX     M8045                    ;8597: 9E 45 
        BEQ     Z85A7                    ;8599: 27 0C 
        CMPD    $05,X                    ;859B: 10 A3 05 
        BNE     Z85A7                    ;859E: 26 07 
        LDA     $05,Y                    ;85A0: A6 25 
        STA     $18,X                    ;85A2: A7 88 18 
        BRA     Z85B5                    ;85A5: 20 0E 
;------------------------------------------------------------------------
Z85A7:	LDX     M8047                    ;85A7: 9E 47 
        BNE     Z85B5                    ;85A9: 26 0A 
        CMPD    $05,X                    ;85AB: 10 A3 05 
        BNE     Z85B5                    ;85AE: 26 05 
        LDA     $05,Y                    ;85B0: A6 25 
        STA     $18,X                    ;85B2: A7 88 18 
Z85B5:	JSR     Z8738                    ;85B5: BD 87 38 
        RTS                              ;85B8: 39 
;------------------------------------------------------------------------

code_85b9_via_U:
        LDX     $04,Y                    ;85B9: AE 24 
        LDA     $17,X                    ;85BB: A6 88 17 
        BNE     Z85C7                    ;85BE: 26 07 
        INC     $17,X                    ;85C0: 6C 88 17 
        JSR     Z8738                    ;85C3: BD 87 38 
        RTS                              ;85C6: 39 
;------------------------------------------------------------------------
Z85C7:	BRA     Z85CB                    ;85C7: 20 02 
;------------------------------------------------------------------------

code_85c9_via_U:
        LDX     $04,Y                    ;85C9: AE 24 
Z85CB:	LDA     $06,Y                    ;85CB: A6 26 
        JSR     Z8738                    ;85CD: BD 87 38 
        CMPA    $19,X                    ;85D0: A1 88 19 
        BEQ     Z85D6                    ;85D3: 27 01 
        RTS                              ;85D5: 39 
;------------------------------------------------------------------------
Z85D6:	JSR     Z8BC1                    ;85D6: BD 8B C1 
        LDU     #M0000                   ;85D9: CE 00 00 
        CMPX    M8045                    ;85DC: 9C 45 
        BNE     Z85E6                    ;85DE: 26 06 
        STU     M8045                    ;85E0: DF 45 
        BSR     Z8617                    ;85E2: 8D 33 
        BRA     Z8609                    ;85E4: 20 23 
;------------------------------------------------------------------------
Z85E6:	CMPX    M8047                    ;85E6: 9C 47 
        BNE     Z85F0                    ;85E8: 26 06 
        STU     M8047                    ;85EA: DF 47 
        BSR     Z863F                    ;85EC: 8D 51 
        BRA     Z8609                    ;85EE: 20 19 
;------------------------------------------------------------------------
Z85F0:	LDA     $07,X                    ;85F0: A6 07 
        BPL     Z85FC                    ;85F2: 2A 08 
        LDU     #vector_803d_U           ;85F4: CE 80 3D 
        JSR     Z86F6                    ;85F7: BD 86 F6 
        BRA     Z8609                    ;85FA: 20 0D 
;------------------------------------------------------------------------
Z85FC:	BITA    #$40                     ;85FC: 85 40 
        BEQ     Z8608                    ;85FE: 27 08 
        LDU     #vector_8041_U           ;8600: CE 80 41 
        JSR     Z86F6                    ;8603: BD 86 F6 
        BRA     Z8609                    ;8606: 20 01 
;------------------------------------------------------------------------
Z8608:	RTS                              ;8608: 39 
;------------------------------------------------------------------------
Z8609:	LDA     #$00                     ;8609: 86 00 
        STA     $07,X                    ;860B: A7 07 
        LDU     #vector_803b_U           ;860D: CE 80 3B 
        JSR     Z8722                    ;8610: BD 87 22 
        JSR     Z8844                    ;8613: BD 88 44 
        RTS                              ;8616: 39 
;------------------------------------------------------------------------
Z8617:	LDA     #$61                     ;8617: 86 61 
        PSHS    A                        ;8619: 34 02 
        LDU     #vector_8056_U           ;861B: CE 80 56 
        LDB     #$1F                     ;861E: C6 1F 
Z8620:	LDA     ,S                       ;8620: A6 E4 
        CMPA    M807D                    ;8622: 91 7D 
        BCS     Z8637                    ;8624: 25 11 
        TFR     B,A                      ;8626: 1F 98 
        ANDA    ,U                       ;8628: A4 C4 
        STA     ,U                       ;862A: A7 C4 
        LSRB                             ;862C: 54 
        BCS     Z8633                    ;862D: 25 04 
        LDB     #$7F                     ;862F: C6 7F 
        LEAU    -$01,U                   ;8631: 33 5F 
Z8633:	DEC     ,S                       ;8633: 6A E4 
        BRA     Z8620                    ;8635: 20 E9 
;------------------------------------------------------------------------
Z8637:	PULS    A                        ;8637: 35 02 
        LDA     #$FF                     ;8639: 86 FF 
        STA     M8106                    ;863B: B7 81 06 
        RTS                              ;863E: 39 
;------------------------------------------------------------------------
Z863F:	LDA     #$24                     ;863F: 86 24 
        PSHS    A                        ;8641: 34 02 
        LDB     #$FE                     ;8643: C6 FE 
        LDU     #table_base_804f         ;8645: CE 80 4F 
Z8648:	LDA     ,S                       ;8648: A6 E4 
        CMPA    M807D                    ;864A: 91 7D 
        BCC     Z865F                    ;864C: 24 11 
        TFR     B,A                      ;864E: 1F 98 
        ANDA    ,U                       ;8650: A4 C4 
        STA     ,U                       ;8652: A7 C4 
        ASLB                             ;8654: 58 
        BCS     Z865B                    ;8655: 25 04 
        LEAU    $01,U                    ;8657: 33 41 
        LDB     #$FE                     ;8659: C6 FE 
Z865B:	INC     ,S                       ;865B: 6C E4 
        BRA     Z8648                    ;865D: 20 E9 
;------------------------------------------------------------------------
Z865F:	PULS    A                        ;865F: 35 02 
        LDA     #$FF                     ;8661: 86 FF 
        STA     M8105                    ;8663: B7 81 05 
        RTS                              ;8666: 39 
;------------------------------------------------------------------------
Z8667:	LDU     #table_base_804f         ;8667: CE 80 4F 
Z866A:	CLR     ,U+                      ;866A: 6F C0 
        CMPU    #vector_8056_U           ;866C: 11 83 80 56 
        BLS     Z866A                    ;8670: 23 F8 
        LDA     #$FF                     ;8672: 86 FF 
        STA     M8106                    ;8674: B7 81 06 
        STA     M8105                    ;8677: B7 81 05 
        RTS                              ;867A: 39 
;------------------------------------------------------------------------

code_867b_via_U:
        LDA     $05,Y                    ;867B: A6 25 
        JSR     Z8738                    ;867D: BD 87 38 
        LDY     vector_8041_U            ;8680: 10 9E 41 
Z8683:	BEQ     Z869F                    ;8683: 27 1A 
        LDB     $07,Y                    ;8685: E6 27 
        BITB    #$01                     ;8687: C5 01 
        BEQ     Z869A                    ;8689: 27 0F 
        CMPA    $05,Y                    ;868B: A1 25 
        BNE     Z869A                    ;868D: 26 0B 
        PSHS    A                        ;868F: 34 02 
        JSR     Z8E05                    ;8691: BD 8E 05 
        LDA     #$40                     ;8694: 86 40 
        STA     $07,Y                    ;8696: A7 27 
        PULS    A                        ;8698: 35 02 
Z869A:	LDY     ,Y                       ;869A: 10 AE A4 
        BRA     Z8683                    ;869D: 20 E4 
;------------------------------------------------------------------------
Z869F:	RTS                              ;869F: 39 
;------------------------------------------------------------------------

code_86a0_via_U:
        LDX     $04,Y                    ;86A0: AE 24 
        PSHS    Y,X                      ;86A2: 34 30 
        LDY     vector_803d_U            ;86A4: 10 9E 3D 
Z86A7:	BEQ     Z86CF                    ;86A7: 27 26 
        LDD     ,S                       ;86A9: EC E4 
        CMPD    $04,Y                    ;86AB: 10 A3 24 
        BNE     Z86CA                    ;86AE: 26 1A 
        JSR     Z8E05                    ;86B0: BD 8E 05 
        TFR     Y,X                      ;86B3: 1F 21 
        LDA     #$40                     ;86B5: 86 40 
        STA     $07,X                    ;86B7: A7 07 
        LDU     #vector_803d_U           ;86B9: CE 80 3D 
        JSR     Z86F6                    ;86BC: BD 86 F6 
        LDU     #vector_8043_U           ;86BF: CE 80 43 
        JSR     Z8722                    ;86C2: BD 87 22 
        LDY     vector_803d_U            ;86C5: 10 9E 3D 
        BRA     Z86CD                    ;86C8: 20 03 
;------------------------------------------------------------------------
Z86CA:	LDY     ,Y                       ;86CA: 10 AE A4 
Z86CD:	BRA     Z86A7                    ;86CD: 20 D8 
;------------------------------------------------------------------------
Z86CF:	JSR     Z8667                    ;86CF: BD 86 67 
        LDY     M8045                    ;86D2: 10 9E 45 
        BEQ     Z86E1                    ;86D5: 27 0A 
        LDD     ,S                       ;86D7: EC E4 
        CMPD    $04,Y                    ;86D9: 10 A3 24 
        BNE     Z86E1                    ;86DC: 26 03 
        JSR     Z8E05                    ;86DE: BD 8E 05 
Z86E1:	LDY     M8047                    ;86E1: 10 9E 47 
        BEQ     Z86F0                    ;86E4: 27 0A 
        LDD     ,S                       ;86E6: EC E4 
        CMPD    $04,Y                    ;86E8: 10 A3 24 
        BNE     Z86F0                    ;86EB: 26 03 
        JSR     Z8E05                    ;86ED: BD 8E 05 
Z86F0:	PULS    Y,X                      ;86F0: 35 30 
        JSR     Z8738                    ;86F2: BD 87 38 
        RTS                              ;86F5: 39 
;------------------------------------------------------------------------
Z86F6:	PSHS    U                        ;86F6: 34 40 
        LEAU    $02,U                    ;86F8: 33 42 
        PSHS    U                        ;86FA: 34 40 
        LDU     $02,X                    ;86FC: EE 02 
        BEQ     Z8710                    ;86FE: 27 10 
        LDY     ,X                       ;8700: 10 AE 84 
        STY     ,U                       ;8703: 10 AF C4 
        BNE     Z870C                    ;8706: 26 04 
        STU     [,S]                     ;8708: EF F4 
        BRA     Z870E                    ;870A: 20 02 
;------------------------------------------------------------------------
Z870C:	STU     $02,Y                    ;870C: EF 22 
Z870E:	BRA     Z871F                    ;870E: 20 0F 
;------------------------------------------------------------------------
Z8710:	LDY     ,X                       ;8710: 10 AE 84 
        STY     [$02,S]                  ;8713: 10 AF F8 02 
        BEQ     Z871D                    ;8717: 27 04 
        STU     $02,Y                    ;8719: EF 22 
        BRA     Z871F                    ;871B: 20 02 
;------------------------------------------------------------------------
Z871D:	STU     [,S]                     ;871D: EF F4 
Z871F:	LEAS    $04,S                    ;871F: 32 64 
        RTS                              ;8721: 39 
;------------------------------------------------------------------------
Z8722:	LDY     ,U                       ;8722: 10 AE C4 
        BNE     Z872B                    ;8725: 26 04 
        STX     -$02,U                   ;8727: AF 5E 
        BRA     Z872D                    ;8729: 20 02 
;------------------------------------------------------------------------
Z872B:	STX     ,Y                       ;872B: AF A4 
Z872D:	STX     ,U                       ;872D: AF C4 
        STY     $02,X                    ;872F: 10 AF 02 
        LDU     #M0000                   ;8732: CE 00 00 
        STU     ,X                       ;8735: EF 84 
        RTS                              ;8737: 39 
;------------------------------------------------------------------------
Z8738:	ORCC    #$50                     ;8738: 1A 50 
        PSHS    A                        ;873A: 34 02 
        LDA     M8207                    ;873C: B6 82 07 
        BNE     Z875A                    ;873F: 26 19 
        LDU     M8057                    ;8741: DE 57 
        STY     M8057                    ;8743: 10 9F 57 
        STU     ,Y                       ;8746: EF A4 
        LDA     kbd_msg_byte_count       ;8748: 96 5D 
        INCA                             ;874A: 4C 
        STA     kbd_msg_byte_count       ;874B: 97 5D 
        CMPA    #$04                     ;874D: 81 04 
        BLS     Z875A                    ;874F: 23 09 
        LDA     M8064                    ;8751: 96 64 
        BEQ     Z875A                    ;8753: 27 05 
        CLR     M8064                    ;8755: 0F 64 
        JSR     kbd_ctrl_ack             ;8757: BD 89 76 
Z875A:	ANDCC   #$AF                     ;875A: 1C AF 
        PULS    PC,A                     ;875C: 35 82 
;------------------------------------------------------------------------

task_handler_875e:
        JSR     ZAE17                    ;875E: BD AE 17 
        LDX     #flag_8038_0_marks_empty_8059_task ;8761: 8E 80 38 
Z8764:	CLR     ,X+                      ;8764: 6F 80 
        CMPX    #M8057                   ;8766: 8C 80 57 
        BCS     Z8764                    ;8769: 25 F9 
        LDA     #$FF                     ;876B: 86 FF 
        STA     M8105                    ;876D: B7 81 05 
        STA     M8106                    ;8770: B7 81 06 
        LDD     #field_248_bytes_8107_via_D ;8773: CC 81 07 
        STD     M8057                    ;8776: DD 57 
        TFR     D,X                      ;8778: 1F 01 
Z877A:	ADDD    #M0008                   ;877A: C3 00 08 
        STD     ,X                       ;877D: ED 84 
        TFR     D,X                      ;877F: 1F 01 
        CMPX    #M81FF                   ;8781: 8C 81 FF 
        BNE     Z877A                    ;8784: 26 F4 
        LDA     #$1F                     ;8786: 86 1F 
        STA     kbd_msg_byte_count       ;8788: 97 5D 
        STA     M8207                    ;878A: B7 82 07 
        LDD     #M0000                   ;878D: CC 00 00 
        STD     ,X                       ;8790: ED 84 
        LDX     #voice1_data             ;8792: 8E B0 52 
        STX     vector_8039_U            ;8795: 9F 39 
Z8797:	TFR     X,D                      ;8797: 1F 10 
        TFR     X,U                      ;8799: 1F 13 
        ADDD    #M004D                   ;879B: C3 00 4D 
        STD     ,X                       ;879E: ED 84 
        STX     vector_803b_U            ;87A0: 9F 3B 
        PSHS    D                        ;87A2: 34 06 
        JSR     Z8844                    ;87A4: BD 88 44 
        PULS    D                        ;87A7: 35 06 
        TFR     D,X                      ;87A9: 1F 01 
        STU     $02,X                    ;87AB: EF 02 
        CMPD    #voiceX_data_end         ;87AD: 10 83 B2 BA 
        BCS     Z8797                    ;87B1: 25 E4 
        LDD     #M0000                   ;87B3: CC 00 00 
        STD     MB054                    ;87B6: FD B0 54 
        LDD     #M0000                   ;87B9: CC 00 00 
        STD     ,U                       ;87BC: ED C4 
        RTS                              ;87BE: 39 
;------------------------------------------------------------------------
Z87BF:	LDU     #code_82ae_via_U         ;87BF: CE 82 AE 
        BRA     Z87D3                    ;87C2: 20 0F 
;------------------------------------------------------------------------
Z87C4:	PSHS    A                        ;87C4: 34 02 
        LDA     kbd_msg_byte_count       ;87C6: 96 5D 
        CMPA    #$04                     ;87C8: 81 04 
        BHI     Z87CE                    ;87CA: 22 02 
        PULS    PC,A                     ;87CC: 35 82 
;------------------------------------------------------------------------
Z87CE:	PULS    A                        ;87CE: 35 02 
        LDU     #code_8380_via_U         ;87D0: CE 83 80 
Z87D3:	EXG     X,D                      ;87D3: 1E 10 
        JMP     Z87F7                    ;87D5: 7E 87 F7 
;------------------------------------------------------------------------
Z87D8:	LDU     #code_857f_via_U         ;87D8: CE 85 7F 
        BRA     Z87D3                    ;87DB: 20 F6 
;------------------------------------------------------------------------
Z87DD:	LDU     #code_867b_via_U         ;87DD: CE 86 7B 
        BRA     Z87F7                    ;87E0: 20 15 
;------------------------------------------------------------------------
Z87E2:	LDU     #code_86a0_via_U         ;87E2: CE 86 A0 
        BRA     Z87F7                    ;87E5: 20 10 
;------------------------------------------------------------------------
Z87E7:	LDU     #code_85c9_via_U         ;87E7: CE 85 C9 
        BRA     Z87F4                    ;87EA: 20 08 
;------------------------------------------------------------------------
Z87EC:	TFR     U,X                      ;87EC: 1F 31 
        LDU     #code_85b9_via_U         ;87EE: CE 85 B9 
        LEAX    -$37,X                   ;87F1: 30 88 C9 
Z87F4:	LDA     $19,X                    ;87F4: A6 88 19 
Z87F7:	PSHS    CC                       ;87F7: 34 01 
        ORCC    #$50                     ;87F9: 1A 50 
        JSR     Z881F                    ;87FB: BD 88 1F 
        LDX     task_vector_805b         ;87FE: 9E 5B 
        BEQ     Z8807                    ;8800: 27 05 
        STY     ,X                       ;8802: 10 AF 84 
        BRA     Z880A                    ;8805: 20 03 
;------------------------------------------------------------------------
Z8807:	STY     task_vector_8059         ;8807: 10 9F 59 
Z880A:	STY     task_vector_805b         ;880A: 10 9F 5B 
        LDD     #M0000                   ;880D: CC 00 00 
        STD     ,Y                       ;8810: ED A4 
        LDA     flag_8038_0_marks_empty_8059_task ;8812: 96 38 
        BEQ     Z8818                    ;8814: 27 02 
        PULS    PC,CC                    ;8816: 35 81 
;------------------------------------------------------------------------
Z8818:	DEC     flag_8038_0_marks_empty_8059_task ;8818: 0A 38 
        ANDCC   #$AF                     ;881A: 1C AF 
        JMP     Z8290                    ;881C: 7E 82 90 
;------------------------------------------------------------------------
Z881F:	LDY     M8057                    ;881F: 10 9E 57 
        BNE     Z8834                    ;8822: 26 10 
        PSHS    U,X,D                    ;8824: 34 56 
        JSR     Z9F60                    ;8826: BD 9F 60 
        JSR     Z9F6F                    ;8829: BD 9F 6F 
        ORCC    #$50                     ;882C: 1A 50 
        DEC     flag_8038_0_marks_empty_8059_task ;882E: 0A 38 
        PULS    U,X,D                    ;8830: 35 56 
        BRA     Z881F                    ;8832: 20 EB 
;------------------------------------------------------------------------
Z8834:	STX     $04,Y                    ;8834: AF 24 
        STD     $06,Y                    ;8836: ED 26 
        STU     $02,Y                    ;8838: EF 22 
        LDX     ,Y                       ;883A: AE A4 
        STX     M8057                    ;883C: 9F 57 
        DEC     kbd_msg_byte_count       ;883E: 0A 5D 
        CLR     M8207                    ;8840: 7F 82 07 
        RTS                              ;8843: 39 
;------------------------------------------------------------------------
Z8844:	LDY     $0E,X                    ;8844: 10 AE 0E 
        LDA     #$03                     ;8847: 86 03 
        ORA     $41,X                    ;8849: AA 88 41 
        STA     $21,Y                    ;884C: A7 A8 21 
        STA     $22,Y                    ;884F: A7 A8 22 
        LDA     #$03                     ;8852: 86 03 
        ORA     $4C,X                    ;8854: AA 88 4C 
        STA     $23,Y                    ;8857: A7 A8 23 
        STA     $24,Y                    ;885A: A7 A8 24 
        RTS                              ;885D: 39 
;------------------------------------------------------------------------

context_switch:
        LDX     context_ptr              ;885E: 9E 5E 
        STS     ,X++                     ;8860: 10 EF 81 
        CMPX    #context_storage_end     ;8863: 8C B2 C6 
        BCS     context_switch_set_ptr   ;8866: 25 03 

context_switch_init_ptr:
        LDX     #context_storage         ;8868: 8E B2 BE 

context_switch_set_ptr:
        STX     context_ptr              ;886B: 9F 5E 
        LDS     ,X                       ;886D: 10 EE 84 
        RTS                              ;8870: 39 
;------------------------------------------------------------------------

IRQ_DOC:
        CLRA                             ;8871: 4F 
        TFR     D,Y                      ;8872: 1F 02 
        LDU     $88BB,Y                  ;8874: EE A9 88 BB 
        ASRB                             ;8878: 57 
        LDY     #DOC_control_base        ;8879: 10 8E EC 5F 
        LEAY    B,Y                      ;887D: 31 A5 
        JSR     [,U]                     ;887F: AD D4 
        ANDCC   #$BF                     ;8881: 1C BF 
        ORCC    #$40                     ;8883: 1A 40 
        LDB     DOC_oir                  ;8885: F6 EC E0 
        BMI     Z8891                    ;8888: 2B 07 
        INC     DOC_irq_cnt              ;888A: 0C 60 
        BNE     IRQ_DOC                  ;888C: 26 E3 
        JSR     ROM_qchipsetup           ;888E: BD F1 BB 
Z8891:	CLR     DOC_irq_cnt              ;8891: 0F 60 
        RTI                              ;8893: 3B 
;------------------------------------------------------------------------

code_8894_via_D:
        LDX     $02,U                    ;8894: AE 42 
        LDD     ,X++                     ;8896: EC 81 
        STA     $01,Y                    ;8898: A7 21 
        STB     $41,Y                    ;889A: E7 A8 41 
        CMPX    $06,U                    ;889D: AC 46 
        BNE     Z88A3                    ;889F: 26 02 
        LDX     $04,U                    ;88A1: AE 44 
Z88A3:	STX     $02,U                    ;88A3: AF 42 

rts_88a5_via_DX:
        RTS                              ;88A5: 39 
;------------------------------------------------------------------------

code_88a6_via_D:
        LDX     $02,U                    ;88A6: AE 42 
        LDD     ,X++                     ;88A8: EC 81 
        STA     $01,Y                    ;88AA: A7 21 
        STB     $41,Y                    ;88AC: E7 A8 41 
        CMPX    $06,U                    ;88AF: AC 46 
        BNE     Z88BF                    ;88B1: 26 0C 
        LDA     #$01                     ;88B3: 86 01 
        ORA     $0A,U                    ;88B5: AA 4A 
        STA     $21,Y                    ;88B7: A7 A8 21 
        LDD     #rts_88a5_via_DX         ;88BA: CC 88 A5 
        STA     ,U                       ;88BD: A7 C4 
Z88BF:	STX     $02,U                    ;88BF: AF 42 
        RTS                              ;88C1: 39 
;------------------------------------------------------------------------

code_88c2_via_D:
        LDX     $02,U                    ;88C2: AE 42 
        LDD     ,X++                     ;88C4: EC 81 
        STA     $01,Y                    ;88C6: A7 21 
        STB     $41,Y                    ;88C8: E7 A8 41 
        STX     $02,U                    ;88CB: AF 42 
        CMPX    $08,U                    ;88CD: AC 48 
        BNE     Z88DD                    ;88CF: 26 0C 
        LDD     #code_88de_via_D         ;88D1: CC 88 DE 
Z88D4:	STD     ,U                       ;88D4: ED C4 
        LDA     #$0B                     ;88D6: 86 0B 
        ORA     $0A,U                    ;88D8: AA 4A 
        STA     $21,Y                    ;88DA: A7 A8 21 
Z88DD:	RTS                              ;88DD: 39 
;------------------------------------------------------------------------

code_88de_via_D:
        LDD     #code_88e3_via_D         ;88DE: CC 88 E3 
        BRA     Z88D4                    ;88E1: 20 F1 
;------------------------------------------------------------------------

code_88e3_via_D:
        LDX     #rts_88a5_via_DX         ;88E3: 8E 88 A5 
        STX     ,U                       ;88E6: AF C4 
        LDA     #$03                     ;88E8: 86 03 
        ORA     $0A,U                    ;88EA: AA 4A 
        STA     $21,Y                    ;88EC: A7 A8 21 
        CLRA                             ;88EF: 4F 
        ASLB                             ;88F0: 58 
        ANDB    #$F8                     ;88F1: C4 F8 
        TFR     D,Y                      ;88F3: 1F 02 
        LDU     $88BC,Y                  ;88F5: EE A9 88 BC 
        JMP     Z87EC                    ;88F9: 7E 87 EC 
;------------------------------------------------------------------------

oscirq_vectors:
        FDB     irq_hdlr_osc00_01        ;88FC: B0 89 
        FDB     irq_hdlr_osc00_01        ;88FE: B0 89 
        FDB     irq_hdlr_osc02_03        ;8900: B0 94 
        FDB     irq_hdlr_osc02_03        ;8902: B0 94 
        FDB     irq_hdlr_osc04_05        ;8904: B0 D6 
        FDB     irq_hdlr_osc04_05        ;8906: B0 D6 
        FDB     irq_hdlr_osc06_07        ;8908: B0 E1 
        FDB     irq_hdlr_osc06_07        ;890A: B0 E1 
        FDB     irq_hdlr_osc08_09        ;890C: B1 23 
        FDB     irq_hdlr_osc08_09        ;890E: B1 23 
        FDB     irq_hdlr_osc10_11        ;8910: B1 2E 
        FDB     irq_hdlr_osc10_11        ;8912: B1 2E 
        FDB     irq_hdlr_osc12_13        ;8914: B1 70 
        FDB     irq_hdlr_osc12_13        ;8916: B1 70 
        FDB     irq_hdlr_osc14_15        ;8918: B1 7B 
        FDB     irq_hdlr_osc14_15        ;891A: B1 7B 
        FDB     irq_hdlr_osc16_17        ;891C: B1 BD 
        FDB     irq_hdlr_osc16_17        ;891E: B1 BD 
        FDB     irq_hdlr_osc18_19        ;8920: B1 C8 
        FDB     irq_hdlr_osc18_19        ;8922: B1 C8 
        FDB     irq_hdlr_osc20_21        ;8924: B2 0A 
        FDB     irq_hdlr_osc20_21        ;8926: B2 0A 
        FDB     irq_hdlr_osc22_23        ;8928: B2 15 
        FDB     irq_hdlr_osc22_23        ;892A: B2 15 
        FDB     irq_hdlr_osc24_25        ;892C: B2 57 
        FDB     irq_hdlr_osc24_25        ;892E: B2 57 
        FDB     irq_hdlr_osc26_27        ;8930: B2 62 
        FDB     irq_hdlr_osc26_27        ;8932: B2 62 
        FDB     irq_hdlr_osc28_29        ;8934: B2 A4 
        FDB     irq_hdlr_osc28_29        ;8936: B2 A4 
        FDB     irq_hdlr_osc30_31        ;8938: B2 AF 
        FDB     irq_hdlr_osc30_31        ;893A: B2 AF 
;------------------------------------------------------------------------

IRQ_entry:
        ORCC    #$40                     ;893C: 1A 40 
        LDA     VIA_isr                  ;893E: B6 E2 0D 
        BPL     IRQ_chk_DOC              ;8941: 2A 1F 
        BITA    #$04                     ;8943: 85 04 
        BEQ     IRQ_chk_VIA_timer        ;8945: 27 03 
        JMP     IRQ_VIA_isr              ;8947: 7E 89 89 
;------------------------------------------------------------------------

IRQ_chk_VIA_timer:
        BITA    #$20                     ;894A: 85 20 
        BEQ     IRQ_chk_VIA_dra          ;894C: 27 03 
        JMP     ROM_timer2int            ;894E: 7E F4 DF 
;------------------------------------------------------------------------

IRQ_chk_VIA_dra:
        BITA    #$02                     ;8951: 85 02 
        BEQ     IRQ_chk_DOC              ;8953: 27 0D 
        LDA     VIA_dr_a                 ;8955: B6 E2 01 
        LDA     word_8025_X              ;8958: 96 25 
        BEQ     Z8961                    ;895A: 27 05 
        INC     M80E9                    ;895C: 0C E9 
        JSR     MIDI_do_timing_clock     ;895E: BD A1 16 
Z8961:	RTI                              ;8961: 3B 
;------------------------------------------------------------------------

IRQ_chk_DOC:
        LDB     DOC_oir                  ;8962: F6 EC E0 
        BMI     IRQ_exit                 ;8965: 2B 03 
        JMP     IRQ_DOC                  ;8967: 7E 88 71 
;------------------------------------------------------------------------

IRQ_exit:
        RTI                              ;896A: 3B 
;------------------------------------------------------------------------

kbd_init_parser:
        BSR     kbd_ctrl_ack             ;896B: 8D 09 
        LDD     #kbd_ctrl_parse          ;896D: CC 89 A1 
        STD     kbd_parser_ptr           ;8970: DD 61 
        LDA     VIA_shr                  ;8972: B6 E2 0A 
        RTS                              ;8975: 39 
;------------------------------------------------------------------------

kbd_ctrl_ack:
        PSHS    CC                       ;8976: 34 01 
        ORCC    #$50                     ;8978: 1A 50 
        LDA     VIA_pcr                  ;897A: B6 E2 0C 
        ANDA    #$FD                     ;897D: 84 FD 
        STA     VIA_pcr                  ;897F: B7 E2 0C 
        ORA     #$0E                     ;8982: 8A 0E 
        STA     VIA_pcr                  ;8984: B7 E2 0C 
        PULS    PC,CC                    ;8987: 35 81 
;------------------------------------------------------------------------

IRQ_VIA_isr:
        LDB     VIA_shr                  ;8989: F6 E2 0A 
        ANDCC   #$BF                     ;898C: 1C BF 
        JSR     [kbd_parser_ptr]         ;898E: AD 9F 80 61 
        ORCC    #$50                     ;8992: 1A 50 
        LDA     kbd_msg_byte_count       ;8994: 96 5D 
        CMPA    #$04                     ;8996: 81 04 
        BCS     Z899E                    ;8998: 25 04 
        BSR     kbd_ctrl_ack             ;899A: 8D DA 
        BRA     kbd_irq_exit             ;899C: 20 02 
;------------------------------------------------------------------------
Z899E:	DEC     M8064                    ;899E: 0A 64 

kbd_irq_exit:
        RTI                              ;89A0: 3B 
;------------------------------------------------------------------------

kbd_ctrl_parse:
        CMPB    #$90                     ;89A1: C1 90 
        BNE     kbd_chk_note_off         ;89A3: 26 07 
        LDD     #kbd_note_on             ;89A5: CC 8A 25 
        STD     kbd_parser_ptr           ;89A8: DD 61 
        BRA     kbd_parser_exit          ;89AA: 20 3F 
;------------------------------------------------------------------------

kbd_chk_note_off:
        CMPB    #$80                     ;89AC: C1 80 
        BNE     kbd_chk_pedal_on         ;89AE: 26 07 
        LDD     #kbd_note_off            ;89B0: CC 89 EC 
        STD     kbd_parser_ptr           ;89B3: DD 61 
        BRA     kbd_parser_exit          ;89B5: 20 34 
;------------------------------------------------------------------------

kbd_chk_pedal_on:
        CMPB    #$B8                     ;89B7: C1 B8 
        BNE     kbd_chk_pedal_off        ;89B9: 26 19 
        LDA     word_8028_X              ;89BB: 96 28 
        BNE     Z89CD                    ;89BD: 26 0E 
        LDA     #$01                     ;89BF: 86 01 
        STA     kbd_flag_damper_pedal_onoff ;89C1: 97 6B 
        LDB     #$7F                     ;89C3: C6 7F 
        JSR     MIDI_set_pedal_to_B      ;89C5: BD A0 DA 
        JSR     pedal_handler_2          ;89C8: BD AD B6 
        BRA     kbd_exit_pedal_on        ;89CB: 20 05 
;------------------------------------------------------------------------
Z89CD:	LDA     #$1B                     ;89CD: 86 1B 
        JSR     pedal_handler_if_8028_not_zero ;89CF: BD A4 04 

kbd_exit_pedal_on:
        BRA     kbd_parser_exit          ;89D2: 20 17 
;------------------------------------------------------------------------

kbd_chk_pedal_off:
        CMPB    #$B9                     ;89D4: C1 B9 
        BNE     kbd_parser_exit          ;89D6: 26 13 
        LDA     word_8028_X              ;89D8: 96 28 
        BNE     kbd_parser_exit          ;89DA: 26 0F 
        CLR     kbd_flag_damper_pedal_onoff ;89DC: 0F 6B 
        CLRB                             ;89DE: 5F 
        JSR     MIDI_set_pedal_to_B      ;89DF: BD A0 DA 
        JSR     pedal_handler_2          ;89E2: BD AD B6 
        LDX     #val_modwheel            ;89E5: 8E 80 68 
        JSR     Z87DD                    ;89E8: BD 87 DD 

kbd_parser_exit:
        RTS                              ;89EB: 39 
;------------------------------------------------------------------------

kbd_note_off:
        ADDB    #$24                     ;89EC: CB 24 
        STB     kbd_normalized_note      ;89EE: D7 63 
        LDD     #kbd_scale_off_velocity  ;89F0: CC 89 F6 
        STD     kbd_parser_ptr           ;89F3: DD 61 
        RTS                              ;89F5: 39 
;------------------------------------------------------------------------

kbd_scale_off_velocity:
        LDX     #ROM_8bit_atanh_offs     ;89F6: 8E FB FE 
        LDB     B,X                      ;89F9: E6 85 
        LDA     osparm_velosens          ;89FB: 96 14 
        SUBA    #$1E                     ;89FD: 80 1E 
        PSHS    A                        ;89FF: 34 02 
        ADDB    ,S+                      ;8A01: EB E0 
        BVC     kbd_minmax_off_vel       ;8A03: 28 02 
        LDB     #$7F                     ;8A05: C6 7F 

kbd_minmax_off_vel:
        BGT     kbd_set_off_vel          ;8A07: 2E 02 
        LDB     #$01                     ;8A09: C6 01 

kbd_set_off_vel:
        LDA     kbd_normalized_note      ;8A0B: 96 63 
        LDU     #kbd_ctrl_parse          ;8A0D: CE 89 A1 
        STU     kbd_parser_ptr           ;8A10: DF 61 
        JSR     MIDI_do_note_off         ;8A12: BD A0 C5 
        JSR     ZADBC                    ;8A15: BD AD BC 
        LDA     kbd_normalized_note      ;8A18: 96 63 
        LDX     #val_modwheel            ;8A1A: 8E 80 68 
        TST     word_801c_X              ;8A1D: 0D 1C 
        BEQ     kbd_exit_scale_off_vel   ;8A1F: 27 03 
        JMP     Z87BF                    ;8A21: 7E 87 BF 
;------------------------------------------------------------------------

kbd_exit_scale_off_vel:
        RTS                              ;8A24: 39 
;------------------------------------------------------------------------

kbd_note_on:
        ADDB    #$24                     ;8A25: CB 24 
        STB     kbd_normalized_note      ;8A27: D7 63 
        LDD     #kbd_scale_on_velocity   ;8A29: CC 8A 2F 
        STD     kbd_parser_ptr           ;8A2C: DD 61 
        RTS                              ;8A2E: 39 
;------------------------------------------------------------------------

kbd_scale_on_velocity:
        LDX     #ROM_8bit_atanh          ;8A2F: 8E FB F8 
        LDB     B,X                      ;8A32: E6 85 
        LDA     osparm_velosens          ;8A34: 96 14 
        SUBA    #$1E                     ;8A36: 80 1E 
        PSHS    A                        ;8A38: 34 02 
        ADDB    ,S+                      ;8A3A: EB E0 
        BVC     kbd_minmax_on_vel        ;8A3C: 28 02 
        LDB     #$7F                     ;8A3E: C6 7F 

kbd_minmax_on_vel:
        BGT     kbd_set_on_vel           ;8A40: 2E 02 
        LDB     #$01                     ;8A42: C6 01 

kbd_set_on_vel:
        LDA     kbd_normalized_note      ;8A44: 96 63 
        LDU     #kbd_ctrl_parse          ;8A46: CE 89 A1 
        STU     kbd_parser_ptr           ;8A49: DF 61 
        JSR     MIDI_do_note_on          ;8A4B: BD A0 B9 
        JSR     adba_note_on_jsr         ;8A4E: BD AD BA 
        LDA     kbd_normalized_note      ;8A51: 96 63 
        LDX     #val_modwheel            ;8A53: 8E 80 68 
        TST     word_801c_X              ;8A56: 0D 1C 
        BEQ     kbd_exit_scale_on_vel    ;8A58: 27 03 
        JMP     Z87C4                    ;8A5A: 7E 87 C4 
;------------------------------------------------------------------------

kbd_exit_scale_on_vel:
        RTS                              ;8A5D: 39 
;------------------------------------------------------------------------
Z8A5E:	LDX     #voice1_data             ;8A5E: 8E B0 52 
        LDY     #DOC_rts_base            ;8A61: 10 8E EC 7F 
        LDU     #MUX_base                ;8A65: CE E4 18 
Z8A68:	BSR     invoke_hdlr_[1C,X]_data_1A,X ;8A68: 8D 23 
        LEAX    $4D,X                    ;8A6A: 30 88 4D 
        LEAY    $04,Y                    ;8A6D: 31 24 
        CMPX    #voiceX_data_end         ;8A6F: 8C B2 BA 
        BCS     Z8A68                    ;8A72: 25 F4 
        CLRA                             ;8A74: 4F 
        STA     -$01,U                   ;8A75: A7 5F 
        RTS                              ;8A77: 39 
;------------------------------------------------------------------------
Z8A78:	PSHS    U,Y                      ;8A78: 34 60 
        EXG     X,Y                      ;8A7A: 1E 12 
        TFR     Y,D                      ;8A7C: 1F 20 
        SUBD    #DOC_rts_base            ;8A7E: 83 EC 7F 
        LSRB                             ;8A81: 54 
        LSRB                             ;8A82: 54 
        LDU     #MUX_base                ;8A83: CE E4 18 
        LEAU    B,U                      ;8A86: 33 C5 
        BSR     invoke_hdlr_[1C,X]_data_1A,X ;8A88: 8D 03 
        PULS    U,Y                      ;8A8A: 35 60 
        RTS                              ;8A8C: 39 
;------------------------------------------------------------------------

invoke_hdlr_[1C,X]_data_1A,X:
        ORCC    #$50                     ;8A8D: 1A 50 
        LDD     $1A,X                    ;8A8F: EC 88 1A 
        JMP     [$1C,X]                  ;8A92: 6E 98 1C 
;------------------------------------------------------------------------

code_8a95_via_D:
        ADDD    $1E,X                    ;8A95: E3 88 1E 
        BCS     Z8A9F                    ;8A98: 25 05 
        CMPA    $20,X                    ;8A9A: A1 88 20 
        BCS     Z8AA9                    ;8A9D: 25 0A 
Z8A9F:	LDD     #code_8aae_via_D         ;8A9F: CC 8A AE 
        STD     $1C,X                    ;8AA2: ED 88 1C 
        LDA     $20,X                    ;8AA5: A6 88 20 
        CLRB                             ;8AA8: 5F 
Z8AA9:	STD     $1A,X                    ;8AA9: ED 88 1A 
        BRA     code_8ad7_via_D          ;8AAC: 20 29 
;------------------------------------------------------------------------

code_8aae_via_D:
        SUBD    $21,X                    ;8AAE: A3 88 21 
        BCS     Z8AB8                    ;8AB1: 25 05 
        CMPA    $23,X                    ;8AB3: A1 88 23 
        BHI     Z8AC2                    ;8AB6: 22 0A 
Z8AB8:	LDD     #code_8ad7_via_D         ;8AB8: CC 8A D7 
        STD     $1C,X                    ;8ABB: ED 88 1C 
        LDA     $23,X                    ;8ABE: A6 88 23 
        CLRB                             ;8AC1: 5F 
Z8AC2:	STD     $1A,X                    ;8AC2: ED 88 1A 
        BRA     code_8ad7_via_D          ;8AC5: 20 10 
;------------------------------------------------------------------------

code_8ac7_via_D:
        SUBD    $24,X                    ;8AC7: A3 88 24 
        BCC     Z8AD4                    ;8ACA: 24 08 
        LDD     #code_8ad7_via_D         ;8ACC: CC 8A D7 
        STD     $1C,X                    ;8ACF: ED 88 1C 
        CLRA                             ;8AD2: 4F 
        CLRB                             ;8AD3: 5F 
Z8AD4:	STD     $1A,X                    ;8AD4: ED 88 1A 

code_8ad7_via_D:
        ANDCC   #$AF                     ;8AD7: 1C AF 
        CMPA    $27,X                    ;8AD9: A1 88 27 
        BLS     Z8AE1                    ;8ADC: 23 03 
        LDA     $27,X                    ;8ADE: A6 88 27 
Z8AE1:	LDB     $28,X                    ;8AE1: E6 88 28 
        JSR     ROM_set_VCF_A_B          ;8AE4: BD F5 E7 
        ORCC    #$50                     ;8AE7: 1A 50 
        LDD     $29,X                    ;8AE9: EC 88 29 
        JMP     [$2B,X]                  ;8AEC: 6E 98 2B 
;------------------------------------------------------------------------

code_8aef_via_D:
        ADDD    $2D,X                    ;8AEF: E3 88 2D 
        BCS     Z8AF9                    ;8AF2: 25 05 
        CMPA    $2F,X                    ;8AF4: A1 88 2F 
        BCS     Z8B0A                    ;8AF7: 25 11 
Z8AF9:	LDD     #code_8b0f_via_D         ;8AF9: CC 8B 0F 
        STD     $2B,X                    ;8AFC: ED 88 2B 
        LDA     $2F,X                    ;8AFF: A6 88 2F 
        LSRA                             ;8B02: 44 
        STA     $2D,X                    ;8B03: A7 88 2D 
        LDA     $2F,X                    ;8B06: A6 88 2F 
        CLRB                             ;8B09: 5F 
Z8B0A:	STD     $29,X                    ;8B0A: ED 88 29 
        BRA     Z8B81                    ;8B0D: 20 72 
;------------------------------------------------------------------------

code_8b0f_via_D:
        SUBD    $30,X                    ;8B0F: A3 88 30 
        BCS     Z8B19                    ;8B12: 25 05 
        CMPA    $32,X                    ;8B14: A1 88 32 
        BHI     Z8B2E                    ;8B17: 22 15 
Z8B19:	LDD     #Z8B81                   ;8B19: CC 8B 81 
        STD     $2B,X                    ;8B1C: ED 88 2B 
        CLRB                             ;8B1F: 5F 
        LDA     $32,X                    ;8B20: A6 88 32 
        BEQ     Z8B51                    ;8B23: 27 2C 
        LSRA                             ;8B25: 44 
        STA     $2D,X                    ;8B26: A7 88 2D 
        LDA     $32,X                    ;8B29: A6 88 32 
        BRA     Z8B44                    ;8B2C: 20 16 
;------------------------------------------------------------------------
Z8B2E:	CMPA    $2D,X                    ;8B2E: A1 88 2D 
        BHI     Z8B44                    ;8B31: 22 11 
        LSR     $30,X                    ;8B33: 64 88 30 
        ROR     $31,X                    ;8B36: 66 88 31 
        INC     $31,X                    ;8B39: 6C 88 31 
        PSHS    A                        ;8B3C: 34 02 
        LSRA                             ;8B3E: 44 
        STA     $2D,X                    ;8B3F: A7 88 2D 
        PULS    A                        ;8B42: 35 02 
Z8B44:	STD     $29,X                    ;8B44: ED 88 29 
        BRA     Z8B81                    ;8B47: 20 38 
;------------------------------------------------------------------------

code_8b49_via_D:
        SUBD    $33,X                    ;8B49: A3 88 33 
        BCS     Z8B51                    ;8B4C: 25 03 
        TSTA                             ;8B4E: 4D 
        BNE     Z8B68                    ;8B4F: 26 17 
Z8B51:	LDD     #code_8bbe_via_DX        ;8B51: CC 8B BE 
        STD     $2B,X                    ;8B54: ED 88 2B 
        CLRB                             ;8B57: 5F 
        CLRA                             ;8B58: 4F 
        STD     $29,X                    ;8B59: ED 88 29 
        PSHS    U,Y,X                    ;8B5C: 34 70 
        JSR     Z87E7                    ;8B5E: BD 87 E7 
        LDD     $29,X                    ;8B61: EC 88 29 
        PULS    U,Y,X                    ;8B64: 35 70 
        BRA     Z8B81                    ;8B66: 20 19 
;------------------------------------------------------------------------
Z8B68:	CMPA    $2D,X                    ;8B68: A1 88 2D 
        BHI     Z8B7E                    ;8B6B: 22 11 
        LSR     $33,X                    ;8B6D: 64 88 33 
        ROR     $34,X                    ;8B70: 66 88 34 
        INC     $34,X                    ;8B73: 6C 88 34 
        PSHS    A                        ;8B76: 34 02 
        LSRA                             ;8B78: 44 
        STA     $2D,X                    ;8B79: A7 88 2D 
        PULS    A                        ;8B7C: 35 02 
Z8B7E:	STD     $29,X                    ;8B7E: ED 88 29 
Z8B81:	LDB     $36,X                    ;8B81: E6 88 36 
        BNE     Z8B97                    ;8B84: 26 11 
        LDB     word_801e_X              ;8B86: D6 1E 
        CMPB    #$09                     ;8B88: C1 09 
        BNE     Z8B91                    ;8B8A: 26 05 
        LDB     $18,X                    ;8B8C: E6 88 18 
        BRA     Z8B94                    ;8B8F: 20 03 
;------------------------------------------------------------------------
Z8B91:	LDB     [$04,X]                  ;8B91: E6 98 04 
Z8B94:	ASLB                             ;8B94: 58 
        BRA     Z8B99                    ;8B95: 20 02 
;------------------------------------------------------------------------
Z8B97:	SUBB    #$01                     ;8B97: C0 01 
Z8B99:	ASLB                             ;8B99: 58 
        BCS     Z8BAB                    ;8B9A: 25 0F 
        PSHS    U,D                      ;8B9C: 34 46 
        MUL                              ;8B9E: 3D 
        ADDA    #$07                     ;8B9F: 8B 07 
        STA     $01,S                    ;8BA1: A7 61 
        LDA     ,S                       ;8BA3: A6 E4 
        ADDA    #$07                     ;8BA5: 8B 07 
        STA     ,S                       ;8BA7: A7 E4 
        BRA     Z8BB9                    ;8BA9: 20 0E 
;------------------------------------------------------------------------
Z8BAB:	PSHS    U,A                      ;8BAB: 34 42 
        COMB                             ;8BAD: 53 
        MUL                              ;8BAE: 3D 
        ADDA    #$07                     ;8BAF: 8B 07 
        PSHS    A                        ;8BB1: 34 02 
        LDA     $01,S                    ;8BB3: A6 61 
        ADDA    #$07                     ;8BB5: 8B 07 
        STA     $01,S                    ;8BB7: A7 61 
Z8BB9:	JSR     ROM_set_DOC_volume_call_hdlrD ;8BB9: BD F6 DD 
        PULS    U                        ;8BBC: 35 40 

code_8bbe_via_DX:
        ANDCC   #$AF                     ;8BBE: 1C AF 
        RTS                              ;8BC0: 39 
;------------------------------------------------------------------------
Z8BC1:	LDA     #$40                     ;8BC1: 86 40 
        STA     $24,X                    ;8BC3: A7 88 24 
        LDD     #code_8ac7_via_D         ;8BC6: CC 8A C7 
        STD     $1C,X                    ;8BC9: ED 88 1C 
        RTS                              ;8BCC: 39 
;------------------------------------------------------------------------
Z8BCD:	LDB     $06,Y                    ;8BCD: E6 26 
        CMPB    M807D                    ;8BCF: D1 7D 
        BCS     Z8BD5                    ;8BD1: 25 02 
        SUBB    #$18                     ;8BD3: C0 18 
Z8BD5:	CLRA                             ;8BD5: 4F 
Z8BD6:	INCA                             ;8BD6: 4C 
        SUBB    #$0C                     ;8BD7: C0 0C 
        BPL     Z8BD6                    ;8BD9: 2A FB 
        DECA                             ;8BDB: 4A 
        ADDB    #$0C                     ;8BDC: CB 0C 
        LDX     #data_8bf1_via_X         ;8BDE: 8E 8B F1 
        LDB     B,X                      ;8BE1: E6 85 
        SUBD    #M03B1                   ;8BE3: 83 03 B1 
        ADDD    $09,U                    ;8BE6: E3 49 
        BPL     Z8BEB                    ;8BE8: 2A 01 
        CLRA                             ;8BEA: 4F 
Z8BEB:	STD     $10,Y                    ;8BEB: ED A8 10 
        JMP     Z8CA0                    ;8BEE: 7E 8C A0 
;------------------------------------------------------------------------

data_8bf1_via_X:
        FCB     $00,$15,$2B,$40,$55,$6B  ;8BF1: 00 15 2B 40 55 6B 
        FCB     $80,$95,$AB,$C0,$D5,$EB  ;8BF7: 80 95 AB C0 D5 EB 
;------------------------------------------------------------------------
Z8BFD:	LDX     #val_modwheel            ;8BFD: 8E 80 68 
Z8C00:	LDD     word_8011_X              ;8C00: FC 80 11 
        ADDD    $01,X                    ;8C03: E3 01 
        STD     $05,X                    ;8C05: ED 05 
        LEAX    $07,X                    ;8C07: 30 07 
        CMPX    #M807D                   ;8C09: 8C 80 7D 
        BCS     Z8C00                    ;8C0C: 25 F2 
        LDY     #voice1_data             ;8C0E: 10 8E B0 52 
Z8C12:	INC     flag_804e_0_disables_call_8059_task ;8C12: 0C 4E 
        JSR     Z8C34                    ;8C14: BD 8C 34 
        LEAY    $4D,Y                    ;8C17: 31 A8 4D 
        PSHS    Y                        ;8C1A: 34 20 
        JSR     Z828C                    ;8C1C: BD 82 8C 
        LDY     ,S                       ;8C1F: 10 AE E4 
        CMPY    #voice5_data             ;8C22: 10 8C B1 86 
        BNE     Z8C2B                    ;8C26: 26 03 
        JSR     context_switch           ;8C28: BD 88 5E 
Z8C2B:	PULS    Y                        ;8C2B: 35 20 
        CMPY    #voiceX_data_end         ;8C2D: 10 8C B2 BA 
        BCS     Z8C12                    ;8C31: 25 DF 
        RTS                              ;8C33: 39 
;------------------------------------------------------------------------
Z8C34:	LDU     $04,Y                    ;8C34: EE 24 
        LDB     $14,Y                    ;8C36: E6 A8 14 
        BNE     Z8C4F                    ;8C39: 26 14 
        LDA     word_801d_X              ;8C3B: 96 1D 
        CMPA    #$09                     ;8C3D: 81 09 
        BNE     Z8C46                    ;8C3F: 26 05 
        LDB     $18,Y                    ;8C41: E6 A8 18 
        BRA     Z8C48                    ;8C44: 20 02 
;------------------------------------------------------------------------
Z8C46:	LDB     $04,U                    ;8C46: E6 44 
Z8C48:	LDX     #ROM_8bit_exp            ;8C48: 8E F7 7D 
        LDB     B,X                      ;8C4B: E6 85 
        BRA     Z8C50                    ;8C4D: 20 01 
;------------------------------------------------------------------------
Z8C4F:	DECB                             ;8C4F: 5A 
Z8C50:	LDA     $13,Y                    ;8C50: A6 A8 13 
        ADDA    $12,Y                    ;8C53: AB A8 12 
        STA     $12,Y                    ;8C56: A7 A8 12 
        LDX     #ROM_8bit_sinpos_XX      ;8C59: 8E F8 CD 
        LDA     A,X                      ;8C5C: A6 86 
        BPL     Z8C65                    ;8C5E: 2A 05 
        NEGA                             ;8C60: 40 
        MUL                              ;8C61: 3D 
        NEGA                             ;8C62: 40 
        BRA     Z8C66                    ;8C63: 20 01 
;------------------------------------------------------------------------
Z8C65:	MUL                              ;8C65: 3D 
Z8C66:	TFR     A,B                      ;8C66: 1F 89 
        SEX                              ;8C68: 1D 
        ADDD    $05,U                    ;8C69: E3 45 
        ADDD    $10,Y                    ;8C6B: E3 A8 10 
        JSR     ROM_unknown1             ;8C6E: BD F5 14 
        PSHS    D                        ;8C71: 34 06 
        ADDB    $15,Y                    ;8C73: EB A8 15 
        ADCA    #$00                     ;8C76: 89 00 
        PSHS    D                        ;8C78: 34 06 
        LDX     $0E,Y                    ;8C7A: AE 2E 
        JSR     ROM_set_DOC_freq_call_hdlrU ;8C7C: BD F5 F1 
        RTS                              ;8C7F: 39 
;------------------------------------------------------------------------
Z8C80:	LDY     #voice1_data             ;8C80: 10 8E B0 52 
Z8C84:	LDD     #code_8ad7_via_D         ;8C84: CC 8A D7 
        STD     $1C,Y                    ;8C87: ED A8 1C 
        CLR     $1A,Y                    ;8C8A: 6F A8 1A 
        LDD     #code_8bbe_via_DX        ;8C8D: CC 8B BE 
        STD     $2B,Y                    ;8C90: ED A8 2B 
        CLR     $29,Y                    ;8C93: 6F A8 29 
        LEAY    $4D,Y                    ;8C96: 31 A8 4D 
        CMPY    #voiceX_data_end         ;8C99: 10 8C B2 BA 
        BCS     Z8C84                    ;8C9D: 25 E5 
        RTS                              ;8C9F: 39 
;------------------------------------------------------------------------
Z8CA0:	LDX     $0A,Y                    ;8CA0: AE 2A 
        LDA     $06,Y                    ;8CA2: A6 26 
        SUBA    #$18                     ;8CA4: 80 18 
        BPL     Z8CA9                    ;8CA6: 2A 01 
        CLRA                             ;8CA8: 4F 
Z8CA9:	LDB     $08,X                    ;8CA9: E6 08 
        MUL                              ;8CAB: 3D 
        RORA                             ;8CAC: 46 
        RORB                             ;8CAD: 56 
        PSHS    B                        ;8CAE: 34 04 
        LDB     $16,Y                    ;8CB0: E6 A8 16 
        SEX                              ;8CB3: 1D 
        ADDB    ,S+                      ;8CB4: EB E0 
        ADCA    #$00                     ;8CB6: 89 00 
        ADDB    $06,X                    ;8CB8: EB 06 
        ADCA    #$00                     ;8CBA: 89 00 
        ADDB    $0C,U                    ;8CBC: EB 4C 
        ADCA    #$00                     ;8CBE: 89 00 
        BEQ     Z8CC9                    ;8CC0: 27 07 
        BPL     Z8CC7                    ;8CC2: 2A 03 
        CLRB                             ;8CC4: 5F 
        BRA     Z8CC9                    ;8CC5: 20 02 
;------------------------------------------------------------------------
Z8CC7:	LDB     #$FF                     ;8CC7: C6 FF 
Z8CC9:	STB     M8065                    ;8CC9: D7 65 
        LDA     $1A,Y                    ;8CCB: A6 A8 1A 
        SUBA    $26,Y                    ;8CCE: A0 A8 26 
        ADDA    M8065                    ;8CD1: 9B 65 
        BCC     Z8CD7                    ;8CD3: 24 02 
        LDA     #$FF                     ;8CD5: 86 FF 
Z8CD7:	STA     $1A,Y                    ;8CD7: A7 A8 1A 
        LDA     $20,Y                    ;8CDA: A6 A8 20 
        SUBA    $26,Y                    ;8CDD: A0 A8 26 
        ADDA    M8065                    ;8CE0: 9B 65 
        BCC     Z8CE6                    ;8CE2: 24 02 
        LDA     #$FF                     ;8CE4: 86 FF 
Z8CE6:	STA     $20,Y                    ;8CE6: A7 A8 20 
        LDA     $23,Y                    ;8CE9: A6 A8 23 
        SUBA    $26,Y                    ;8CEC: A0 A8 26 
        ADDA    M8065                    ;8CEF: 9B 65 
        BCC     Z8CF5                    ;8CF1: 24 02 
        LDA     #$FF                     ;8CF3: 86 FF 
Z8CF5:	STA     $23,Y                    ;8CF5: A7 A8 23 
        STB     $26,Y                    ;8CF8: E7 A8 26 
        LDA     $0D,U                    ;8CFB: A6 4D 
        ADDA    #$39                     ;8CFD: 8B 39 
        STA     $27,Y                    ;8CFF: A7 A8 27 
        RTS                              ;8D02: 39 
;------------------------------------------------------------------------
Z8D03:	LDX     $0A,Y                    ;8D03: AE 2A 
        LDU     $0C,Y                    ;8D05: EE 2C 
        LDA     osparm_upperlower        ;8D07: B6 80 15 
        CMPX    #tab_b76f_step36         ;8D0A: 8C B7 6F 
        BCC     Z8D1B                    ;8D0D: 24 0C 
        ASLA                             ;8D0F: 48 
        CMPA    #$80                     ;8D10: 81 80 
        BHI     Z8D18                    ;8D12: 22 04 
        LDA     #$7F                     ;8D14: 86 7F 
        BRA     Z8D19                    ;8D16: 20 01 
;------------------------------------------------------------------------
Z8D18:	NEGA                             ;8D18: 40 
Z8D19:	BRA     Z8D20                    ;8D19: 20 05 
;------------------------------------------------------------------------
Z8D1B:	ASLA                             ;8D1B: 48 
        BPL     Z8D20                    ;8D1C: 2A 02 
        LDA     #$7F                     ;8D1E: 86 7F 
Z8D20:	ADDA    #$20                     ;8D20: 8B 20 
        LDB     $0B,U                    ;8D22: E6 4B 
        ASLB                             ;8D24: 58 
        ASLB                             ;8D25: 58 
        MUL                              ;8D26: 3D 
        STA     M8067                    ;8D27: 97 67 
        LDA     $08,Y                    ;8D29: A6 28 
        STA     M8065                    ;8D2B: 97 65 
        LDA     $06,Y                    ;8D2D: A6 26 
        SUBA    #$24                     ;8D2F: 80 24 
        STA     M8066                    ;8D31: 97 66 
        LDB     $03,X                    ;8D33: E6 03 
        CMPB    #$01                     ;8D35: C1 01 
        BEQ     Z8D3E                    ;8D37: 27 05 
        CMPA    #$10                     ;8D39: 81 10 
        BCC     Z8D3E                    ;8D3B: 24 01 
        ASRB                             ;8D3D: 57 
Z8D3E:	STB     $15,Y                    ;8D3E: E7 A8 15 
        LDA     $07,X                    ;8D41: A6 07 
        STA     $28,Y                    ;8D43: A7 A8 28 
        LDA     $01,X                    ;8D46: A6 01 
        STA     $13,Y                    ;8D48: A7 A8 13 
        LDA     $02,X                    ;8D4B: A6 02 
        STA     $14,Y                    ;8D4D: A7 A8 14 
        CLR     $12,Y                    ;8D50: 6F A8 12 
        LDA     $05,X                    ;8D53: A6 05 
        BEQ     Z8D65                    ;8D55: 27 0E 
        SUBA    #$04                     ;8D57: 80 04 
        LDB     M8065                    ;8D59: D6 65 
        ASLA                             ;8D5B: 48 
        ASLB                             ;8D5C: 58 
        MUL                              ;8D5D: 3D 
        INCA                             ;8D5E: 4C 
        ADDA    $04,X                    ;8D5F: AB 04 
        BCC     Z8D65                    ;8D61: 24 02 
        LDA     #$FF                     ;8D63: 86 FF 
Z8D65:	STA     $36,Y                    ;8D65: A7 A8 36 
        CLRA                             ;8D68: 4F 
        CLRB                             ;8D69: 5F 
        STD     $29,Y                    ;8D6A: ED A8 29 
        STD     $1A,Y                    ;8D6D: ED A8 1A 
        STA     $26,Y                    ;8D70: A7 A8 26 
        LDD     #code_8a95_via_D         ;8D73: CC 8A 95 
        STD     $1C,Y                    ;8D76: ED A8 1C 
        LDD     #code_8aef_via_D         ;8D79: CC 8A EF 
        STD     $2B,Y                    ;8D7C: ED A8 2B 
        LDU     #ROM_16bit_1exp          ;8D7F: CE F7 FD 
        JSR     Z8DA1                    ;8D82: BD 8D A1 
        LEAX    $0A,X                    ;8D85: 30 0A 
        LEAY    $0F,Y                    ;8D87: 31 2F 
        JSR     Z8DA1                    ;8D89: BD 8D A1 
        LEAY    -$0F,Y                   ;8D8C: 31 31 
        LDA     M8067                    ;8D8E: 96 67 
        LDB     $2F,Y                    ;8D90: E6 A8 2F 
        MUL                              ;8D93: 3D 
        STA     $2F,Y                    ;8D94: A7 A8 2F 
        LDA     M8067                    ;8D97: 96 67 
        LDB     $32,Y                    ;8D99: E6 A8 32 
        MUL                              ;8D9C: 3D 
        STA     $32,Y                    ;8D9D: A7 A8 32 
        RTS                              ;8DA0: 39 
;------------------------------------------------------------------------
Z8DA1:	LDA     $11,X                    ;8DA1: A6 88 11 
        LDB     M8065                    ;8DA4: D6 65 
        MUL                              ;8DA6: 3D 
        NEGA                             ;8DA7: 40 
        ADDA    $0C,X                    ;8DA8: AB 0C 
        BSR     Z8DF6                    ;8DAA: 8D 4A 
        STD     $1E,Y                    ;8DAC: ED A8 1E 
        LDA     $12,X                    ;8DAF: A6 88 12 
        LDB     M8065                    ;8DB2: D6 65 
        MUL                              ;8DB4: 3D 
        ADDA    $0D,X                    ;8DB5: AB 0D 
        BPL     Z8DBA                    ;8DB7: 2A 01 
        CLRA                             ;8DB9: 4F 
Z8DBA:	CMPA    #$1F                     ;8DBA: 81 1F 
        BLS     Z8DC0                    ;8DBC: 23 02 
        LDA     #$1F                     ;8DBE: 86 1F 
Z8DC0:	PSHS    A                        ;8DC0: 34 02 
        ASLA                             ;8DC2: 48 
        ASLA                             ;8DC3: 48 
        ASLA                             ;8DC4: 48 
        STA     $20,Y                    ;8DC5: A7 A8 20 
        LDA     $13,X                    ;8DC8: A6 88 13 
        LDB     M8066                    ;8DCB: D6 66 
        MUL                              ;8DCD: 3D 
        NEGA                             ;8DCE: 40 
        ASR     ,S                       ;8DCF: 67 E4 
        ASR     ,S                       ;8DD1: 67 E4 
        SUBA    ,S+                      ;8DD3: A0 E0 
        ADDA    #$08                     ;8DD5: 8B 08 
        ADDA    $0E,X                    ;8DD7: AB 0E 
        BSR     Z8DF6                    ;8DD9: 8D 1B 
        STD     $21,Y                    ;8DDB: ED A8 21 
        LDA     $14,X                    ;8DDE: A6 88 14 
        LDB     M8065                    ;8DE1: D6 65 
        MUL                              ;8DE3: 3D 
        ADDA    $0F,X                    ;8DE4: AB 0F 
        BPL     Z8DE9                    ;8DE6: 2A 01 
        CLRA                             ;8DE8: 4F 
Z8DE9:	CMPA    #$1F                     ;8DE9: 81 1F 
        BLS     Z8DEF                    ;8DEB: 23 02 
        LDA     #$1F                     ;8DED: 86 1F 
Z8DEF:	ASLA                             ;8DEF: 48 
        ASLA                             ;8DF0: 48 
        ASLA                             ;8DF1: 48 
        STA     $23,Y                    ;8DF2: A7 A8 23 
        RTS                              ;8DF5: 39 
;------------------------------------------------------------------------
Z8DF6:	BPL     Z8DFB                    ;8DF6: 2A 03 
        CLRA                             ;8DF8: 4F 
        BRA     Z8E01                    ;8DF9: 20 06 
;------------------------------------------------------------------------
Z8DFB:	CMPA    #$1F                     ;8DFB: 81 1F 
        BLS     Z8E01                    ;8DFD: 23 02 
        LDA     #$1F                     ;8DFF: 86 1F 
Z8E01:	ASLA                             ;8E01: 48 
        LDD     A,U                      ;8E02: EC C6 
        RTS                              ;8E04: 39 
;------------------------------------------------------------------------
Z8E05:	LDX     $0A,Y                    ;8E05: AE 2A 
        LDU     #ROM_16bit_1exp          ;8E07: CE F7 FD 
        LDD     #code_8ac7_via_D         ;8E0A: CC 8A C7 
        STD     $1C,Y                    ;8E0D: ED A8 1C 
        LDD     #code_8b49_via_D         ;8E10: CC 8B 49 
        STD     $2B,Y                    ;8E13: ED A8 2B 
        LDB     $09,Y                    ;8E16: E6 29 
        LDA     $15,X                    ;8E18: A6 88 15 
        MUL                              ;8E1B: 3D 
        NEGA                             ;8E1C: 40 
        ADDA    $10,X                    ;8E1D: AB 88 10 
        BSR     Z8DF6                    ;8E20: 8D D4 
        STD     $24,Y                    ;8E22: ED A8 24 
        LDB     $09,Y                    ;8E25: E6 29 
        LDA     $1F,X                    ;8E27: A6 88 1F 
        MUL                              ;8E2A: 3D 
        NEGA                             ;8E2B: 40 
        ADDA    $1A,X                    ;8E2C: AB 88 1A 
        LDB     $29,Y                    ;8E2F: E6 A8 29 
        LSRB                             ;8E32: 54 
        STB     $2D,Y                    ;8E33: E7 A8 2D 
        LSRB                             ;8E36: 54 
        LSRB                             ;8E37: 54 
        LSRB                             ;8E38: 54 
        SUBB    #$08                     ;8E39: C0 08 
        PSHS    B                        ;8E3B: 34 04 
        SUBA    ,S+                      ;8E3D: A0 E0 
        BSR     Z8DF6                    ;8E3F: 8D B5 
        STD     $33,Y                    ;8E41: ED A8 33 
        RTS                              ;8E44: 39 
;------------------------------------------------------------------------
Z8E45:	LDB     $06,Y                    ;8E45: E6 26 
        CMPB    #$24                     ;8E47: C1 24 
        BCC     Z8E4D                    ;8E49: 24 02 
        LDB     #$24                     ;8E4B: C6 24 
Z8E4D:	CMPB    #$61                     ;8E4D: C1 61 
        BLS     Z8E53                    ;8E4F: 23 02 
        LDB     #$61                     ;8E51: C6 61 
Z8E53:	LDU     #Z8E4D                   ;8E53: CE 8E 4D 
        LDA     B,U                      ;8E56: A6 C5 
        ANDA    #$0F                     ;8E58: 84 0F 
        CMPB    M807D                    ;8E5A: D1 7D 
        BCC     Z8E65                    ;8E5C: 24 07 
        LDX     vec_80a7                 ;8E5E: 9E A7 
        LDU     #vectors_8eaf            ;8E60: CE 8E AF 
        BRA     Z8E6A                    ;8E63: 20 05 
;------------------------------------------------------------------------
Z8E65:	LDX     vec_80a5                 ;8E65: 9E A5 
        LDU     #vectors_8ebf            ;8E67: CE 8E BF 
Z8E6A:	STX     $0A,Y                    ;8E6A: AF 2A 
        LDU     A,U                      ;8E6C: EE C6 
        STU     $0C,Y                    ;8E6E: EF 2C 
        RTS                              ;8E70: 39 
;------------------------------------------------------------------------

data_8e71_via_U:
        FCB     $00,$00,$00,$00,$00,$00  ;8E71: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E77: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E7D: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E83: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E89: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E8F: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E95: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8E9B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8EA1: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;8EA7: 00 00 00 00 00 00 
        FCB     $00,$00                  ;8EAD: 00 00 

vectors_8eaf:
        FDB     vec0_via_8eaf            ;8EAF: B3 1E 
        FDB     vec1_via_8eaf            ;8EB1: B3 36 
        FDB     vec2_via_8eaf            ;8EB3: B3 4E 
        FDB     vec3_via_8eaf            ;8EB5: B3 66 
        FDB     vec4_via_8eaf            ;8EB7: B3 7E 
        FDB     vec5_via_8eaf            ;8EB9: B3 96 
        FDB     vec6_via_8eaf            ;8EBB: B3 AE 
        FDB     vec7_via_8eaf            ;8EBD: B3 C6 

vectors_8ebf:
        FDB     vec0_via_8ebf            ;8EBF: B5 8F 
        FDB     vec1_via_8ebf            ;8EC1: B5 A7 
        FDB     vec2_via_8ebf            ;8EC3: B5 BF 
        FDB     vec3_via_8ebf            ;8EC5: B5 D7 
        FDB     vec4_via_8ebf            ;8EC7: B5 EF 
        FDB     vec5_via_8ebf            ;8EC9: B6 07 
        FDB     vec6_via_8ebf            ;8ECB: B6 1F 
        FDB     vec7_via_8ebf            ;8ECD: B6 37 
;------------------------------------------------------------------------
Z8ECF:	LDY     vec_80a7                 ;8ECF: 10 9E A7 
        LDX     #vectors_8eaf            ;8ED2: 8E 8E AF 
        LDU     #data_8e71_via_U         ;8ED5: CE 8E 71 
        CLRA                             ;8ED8: 4F 
        BSR     Z8EEC                    ;8ED9: 8D 11 
        PSHS    A                        ;8EDB: 34 02 
        LDY     vec_80a5                 ;8EDD: 10 9E A5 
        LDX     #vectors_8ebf            ;8EE0: 8E 8E BF 
        BSR     Z8EEC                    ;8EE3: 8D 07 
        PULS    A                        ;8EE5: 35 02 
        ADDA    #$24                     ;8EE7: 8B 24 
        STA     M807D                    ;8EE9: 97 7D 
        RTS                              ;8EEB: 39 
;------------------------------------------------------------------------
Z8EEC:	LDB     $0A,Y                    ;8EEC: E6 2A 
        ASLB                             ;8EEE: 58 
        LDX     B,X                      ;8EEF: AE 85 
Z8EF1:	CMPA    $0E,X                    ;8EF1: A1 0E 
        BHI     Z8EFA                    ;8EF3: 22 05 
        STB     A,U                      ;8EF5: E7 C6 
        INCA                             ;8EF7: 4C 
        BRA     Z8EF1                    ;8EF8: 20 F7 
;------------------------------------------------------------------------
Z8EFA:	LEAX    $18,X                    ;8EFA: 30 88 18 
        ADDB    #$02                     ;8EFD: CB 02 
        TST     $0B,Y                    ;8EFF: 6D 2B 
        BEQ     Z8F08                    ;8F01: 27 05 
        LEAX    $18,X                    ;8F03: 30 88 18 
        ADDB    #$02                     ;8F06: CB 02 
Z8F08:	CMPA    #$3C                     ;8F08: 81 3C 
        BHI     Z8F10                    ;8F0A: 22 04 
        CMPB    #$0E                     ;8F0C: C1 0E 
        BLS     Z8EF1                    ;8F0E: 23 E1 
Z8F10:	RTS                              ;8F10: 39 
;------------------------------------------------------------------------
Z8F11:	PSHS    Y,D                      ;8F11: 34 26 
        CLRA                             ;8F13: 4F 
        CMPY    #vec0_via_8ebf           ;8F14: 10 8C B5 8F 
        BCS     Z8F1C                    ;8F18: 25 02 
        LDA     #$40                     ;8F1A: 86 40 
Z8F1C:	STA     M807E                    ;8F1C: 97 7E 
        JSR     Z98EB                    ;8F1E: BD 98 EB 
        PULS    Y,D                      ;8F21: 35 26 
        LDX     #data_8ff9               ;8F23: 8E 8F F9 
        LDU     ,Y                       ;8F26: EE A4 
        CMPB    #$08                     ;8F28: C1 08 
        BNE     Z8F2E                    ;8F2A: 26 02 
        STA     B,Y                      ;8F2C: A7 A5 
Z8F2E:	CMPB    #$0F                     ;8F2E: C1 0F 
        BNE     Z8F3B                    ;8F30: 26 09 
        CMPA    $10,Y                    ;8F32: A1 A8 10 
        BHI     Z8F58                    ;8F35: 22 21 
        STA     B,Y                      ;8F37: A7 A5 
        BRA     Z8F45                    ;8F39: 20 0A 
;------------------------------------------------------------------------
Z8F3B:	CMPB    #$10                     ;8F3B: C1 10 
        BNE     Z8F5C                    ;8F3D: 26 1D 
        CMPA    $0F,Y                    ;8F3F: A1 2F 
        BLS     Z8F58                    ;8F41: 23 15 
        STA     B,Y                      ;8F43: A7 A5 
Z8F45:	CLR     $08,Y                    ;8F45: 6F 28 
        LDA     #$FF                     ;8F47: 86 FF 
        STA     $13,Y                    ;8F49: A7 A8 13 
        LDA     $10,Y                    ;8F4C: A6 A8 10 
        DECA                             ;8F4F: 4A 
        STA     $11,Y                    ;8F50: A7 A8 11 
        STA     $12,Y                    ;8F53: A7 A8 12 
        BRA     Z8F87                    ;8F56: 20 2F 
;------------------------------------------------------------------------
Z8F58:	JSR     Z9941                    ;8F58: BD 99 41 
        RTS                              ;8F5B: 39 
;------------------------------------------------------------------------
Z8F5C:	CMPB    #$11                     ;8F5C: C1 11 
        BNE     Z8F6B                    ;8F5E: 26 0B 
        CMPA    $0F,Y                    ;8F60: A1 2F 
        BCS     Z8F58                    ;8F62: 25 F4 
        CMPA    $12,Y                    ;8F64: A1 A8 12 
        BHI     Z8F58                    ;8F67: 22 EF 
        STA     B,Y                      ;8F69: A7 A5 
Z8F6B:	CMPB    #$12                     ;8F6B: C1 12 
        BNE     Z8F80                    ;8F6D: 26 11 
        CMPA    $11,Y                    ;8F6F: A1 A8 11 
        BCS     Z8F58                    ;8F72: 25 E4 
        CMPA    $10,Y                    ;8F74: A1 A8 10 
        BHI     Z8F58                    ;8F77: 22 DF 
        STA     B,Y                      ;8F79: A7 A5 
        LDA     #$FF                     ;8F7B: 86 FF 
        STA     $13,Y                    ;8F7D: A7 A8 13 
Z8F80:	CMPB    #$13                     ;8F80: C1 13 
        BNE     Z8F87                    ;8F82: 26 03 
        STA     $13,Y                    ;8F84: A7 A8 13 
Z8F87:	LDA     $0F,Y                    ;8F87: A6 2F 
        CLR     M8081                    ;8F89: 0F 81 
        TST     $08,Y                    ;8F8B: 6D 28 
        BEQ     Z8FAA                    ;8F8D: 27 1B 
        CMPA    $11,Y                    ;8F8F: A1 A8 11 
        BEQ     Z8F9E                    ;8F92: 27 0A 
        STA     M807F                    ;8F94: 97 7F 
        LDA     $12,Y                    ;8F96: A6 A8 12 
        STA     M8080                    ;8F99: 97 80 
        JSR     Z8FC8                    ;8F9B: BD 8F C8 
Z8F9E:	INC     M8081                    ;8F9E: 0C 81 
        STU     $04,Y                    ;8FA0: EF 24 
        LDA     $11,Y                    ;8FA2: A6 A8 11 
        LDB     $12,Y                    ;8FA5: E6 A8 12 
        BRA     Z8FAD                    ;8FA8: 20 03 
;------------------------------------------------------------------------
Z8FAA:	LDB     $10,Y                    ;8FAA: E6 A8 10 
Z8FAD:	STA     M807F                    ;8FAD: 97 7F 
        STB     M8080                    ;8FAF: D7 80 
        JSR     Z8FC8                    ;8FB1: BD 8F C8 
        STU     $06,Y                    ;8FB4: EF 26 
        STU     $02,Y                    ;8FB6: EF 22 
        LDA     M8081                    ;8FB8: 96 81 
        LDB     $13,Y                    ;8FBA: E6 A8 13 
        INCB                             ;8FBD: 5C 
        BEQ     Z8FC1                    ;8FBE: 27 01 
        CLRA                             ;8FC0: 4F 
Z8FC1:	STA     $14,Y                    ;8FC1: A7 A8 14 
        JSR     Z9941                    ;8FC4: BD 99 41 
        RTS                              ;8FC7: 39 
;------------------------------------------------------------------------
Z8FC8:	LDA     M807F                    ;8FC8: 96 7F 
Z8FCA:	STA     ,U+                      ;8FCA: A7 C0 
        ORA     #$80                     ;8FCC: 8A 80 
        CLRB                             ;8FCE: 5F 
        LSRA                             ;8FCF: 44 
Z8FD0:	BCS     Z8FD6                    ;8FD0: 25 04 
        INCB                             ;8FD2: 5C 
        LSRA                             ;8FD3: 44 
        BRA     Z8FD0                    ;8FD4: 20 FA 
;------------------------------------------------------------------------
Z8FD6:	LDA     M807F                    ;8FD6: 96 7F 
        ADDA    B,X                      ;8FD8: AB 85 
        TST     M8081                    ;8FDA: 0D 81 
        BEQ     Z8FE5                    ;8FDC: 27 07 
        CMPA    M8080                    ;8FDE: 91 80 
        BLS     Z8FE5                    ;8FE0: 23 03 
        DECB                             ;8FE2: 5A 
        BRA     Z8FD6                    ;8FE3: 20 F1 
;------------------------------------------------------------------------
Z8FE5:	ADDB    #$08                     ;8FE5: CB 08 
        LDB     B,X                      ;8FE7: E6 85 
        ORB     M807E                    ;8FE9: DA 7E 
        STB     ,U+                      ;8FEB: E7 C0 
        CMPA    M8080                    ;8FED: 91 80 
        BCC     Z8FF8                    ;8FEF: 24 07 

code_8ff1_via_X:
        INCA                             ;8FF1: 4C 
        STA     M807F                    ;8FF2: 97 7F 
        CLR     M8081                    ;8FF4: 0F 81 
        BRA     Z8FCA                    ;8FF6: 20 D2 
;------------------------------------------------------------------------
Z8FF8:	RTS                              ;8FF8: 39 
;------------------------------------------------------------------------

data_8ff9:
        FCB     $00,$01,$03,$07,$0F,$1F  ;8FF9: 00 01 03 07 0F 1F 
        FCB     $3F,$7F,$00,$09,$12,$1B  ;8FFF: 3F 7F 00 09 12 1B 
        FCB     $24,$2D,$36,$3F          ;9005: 24 2D 36 3F 

adc_pitchwheel_last:
        FCB     $40                      ;9009: 40 

adc_result:
        FCB     $00                      ;900A: 00 

adc_modwheel_last:
        FCB     $00                      ;900B: 00 

adc_buf1:
        FCB     $00                      ;900C: 00 

adc_buf2:
        FCB     $00                      ;900D: 00 

adc_buf3:
        FCB     $00                      ;900E: 00 
;------------------------------------------------------------------------

task0_code_D:
        LDA     M802F                    ;900F: 96 2F 
        BPL     Z901A                    ;9011: 2A 07 
        INC     M802F                    ;9013: 0C 2F 
        JSR     Z8A5E                    ;9015: BD 8A 5E 
        BRA     Z901D                    ;9018: 20 03 
;------------------------------------------------------------------------
Z901A:	JSR     context_switch           ;901A: BD 88 5E 
Z901D:	BRA     task0_code_D             ;901D: 20 F0 
;------------------------------------------------------------------------

task1_code_D:
        JSR     context_switch           ;901F: BD 88 5E 
        LDA     M8030                    ;9022: 96 30 
        BPL     task1_code_D             ;9024: 2A F9 
        CLR     M8030                    ;9026: 0F 30 
        JSR     Z9039                    ;9028: BD 90 39 
Z902B:	JSR     context_switch           ;902B: BD 88 5E 
        LDA     M8030                    ;902E: 96 30 
        BPL     Z902B                    ;9030: 2A F9 
        CLR     M8030                    ;9032: 0F 30 
        JSR     Z8BFD                    ;9034: BD 8B FD 
        BRA     task1_code_D             ;9037: 20 E6 
;------------------------------------------------------------------------
Z9039:	ORCC    #$50                     ;9039: 1A 50 
        LDA     VIA_dr_b                 ;903B: B6 E2 00 
        ANDA    #$FB                     ;903E: 84 FB 
        ORA     #$08                     ;9040: 8A 08 
        STA     VIA_dr_b                 ;9042: B7 E2 00 
        ANDCC   #$AF                     ;9045: 1C AF 
        LDA     DOC_oer                  ;9047: B6 EC E1 
        LDA     DOC_adc                  ;904A: B6 EC E2 
        JSR     context_switch           ;904D: BD 88 5E 
        ORCC    #$50                     ;9050: 1A 50 
        LDB     DOC_adc                  ;9052: F6 EC E2 
        LDA     VIA_dr_b                 ;9055: B6 E2 00 
        ORA     #$0C                     ;9058: 8A 0C 
        STA     VIA_dr_b                 ;905A: B7 E2 00 
        ANDCC   #$AF                     ;905D: 1C AF 
        STB     adc_buf1                 ;905F: F7 90 0C 
        CLRA                             ;9062: 4F 
        ADDB    adc_buf2                 ;9063: FB 90 0D 
        ADCA    #$00                     ;9066: 89 00 
        ADDB    adc_buf3                 ;9068: FB 90 0E 
        ADCA    #$00                     ;906B: 89 00 
        ASRA                             ;906D: 47 
        RORB                             ;906E: 56 
        ASRA                             ;906F: 47 
        RORB                             ;9070: 56 
        LDA     DOC_oer                  ;9071: B6 EC E1 
        LDA     DOC_adc                  ;9074: B6 EC E2 
        SUBB    adc_result               ;9077: F0 90 0A 
        BPL     Z9083                    ;907A: 2A 07 
        ADDB    #$08                     ;907C: CB 08 
        BMI     Z9081                    ;907E: 2B 01 
        CLRB                             ;9080: 5F 
Z9081:	BRA     Z9088                    ;9081: 20 05 
;------------------------------------------------------------------------
Z9083:	SUBB    #$08                     ;9083: C0 08 
        BPL     Z9088                    ;9085: 2A 01 
        CLRB                             ;9087: 5F 
Z9088:	ADDB    #$40                     ;9088: CB 40 
        BVC     Z908E                    ;908A: 28 02 
        LDB     #$7F                     ;908C: C6 7F 
Z908E:	BPL     Z9091                    ;908E: 2A 01 
        CLRB                             ;9090: 5F 
Z9091:	CMPB    adc_pitchwheel_last      ;9091: F1 90 09 
        BEQ     Z90A3                    ;9094: 27 0D 
        STB     adc_pitchwheel_last      ;9096: F7 90 09 
        JSR     MIDI_set_pwheel_to_B     ;9099: BD A0 CF 
        JSR     ZADAF                    ;909C: BD AD AF 
        BSR     Z90C0                    ;909F: 8D 1F 
        STD     val_pitchwheel           ;90A1: DD 69 
Z90A3:	LDD     adc_buf1                 ;90A3: FC 90 0C 
        STD     adc_buf2                 ;90A6: FD 90 0D 
        LDB     DOC_adc                  ;90A9: F6 EC E2 
        LSRB                             ;90AC: 54 
        CMPB    adc_modwheel_last        ;90AD: F1 90 0B 
        BEQ     Z90BF                    ;90B0: 27 0D 
        STB     adc_modwheel_last        ;90B2: F7 90 0B 
        STB     val_modwheel             ;90B5: D7 68 
        STB     val_modwheel_related     ;90B7: D7 6C 
        JSR     MIDI_set_mwheel_to_B     ;90B9: BD A0 E2 
        JSR     ZADB2                    ;90BC: BD AD B2 
Z90BF:	RTS                              ;90BF: 39 
;------------------------------------------------------------------------
Z90C0:	LDA     #$AB                     ;90C0: 86 AB 
        SUBB    #$40                     ;90C2: C0 40 
        BPL     Z90CB                    ;90C4: 2A 05 
        MUL                              ;90C6: 3D 
        SUBA    #$2B                     ;90C7: 80 2B 
        BRA     Z90D1                    ;90C9: 20 06 
;------------------------------------------------------------------------
Z90CB:	CMPB    #$3F                     ;90CB: C1 3F 
        BNE     Z90D0                    ;90CD: 26 01 
        INCB                             ;90CF: 5C 
Z90D0:	MUL                              ;90D0: 3D 
Z90D1:	ASLB                             ;90D1: 58 
        LDB     osparm_bendrange         ;90D2: D6 13 
        ROLA                             ;90D4: 49 
        BPL     Z90DC                    ;90D5: 2A 05 
        MUL                              ;90D7: 3D 
        SUBA    osparm_bendrange         ;90D8: 90 13 
        BRA     Z90DD                    ;90DA: 20 01 
;------------------------------------------------------------------------
Z90DC:	MUL                              ;90DC: 3D 
Z90DD:	ASRA                             ;90DD: 47 
        RORB                             ;90DE: 56 
        ASRA                             ;90DF: 47 
        RORB                             ;90E0: 56 
        RTS                              ;90E1: 39 
;------------------------------------------------------------------------

task2_code_D:
        JSR     Z9D4B                    ;90E2: BD 9D 4B 
        BSR     Z90E9                    ;90E5: 8D 02 
        BRA     task2_code_D             ;90E7: 20 F9 
;------------------------------------------------------------------------
Z90E9:	LDA     M80AE                    ;90E9: 96 AE 
        CMPA    #$0A                     ;90EB: 81 0A 
        BCC     Z90F3                    ;90ED: 24 04 
        JSR     Z9258                    ;90EF: BD 92 58 
        RTS                              ;90F2: 39 
;------------------------------------------------------------------------
Z90F3:	LDA     M80AE                    ;90F3: 96 AE 
        CMPA    #$10                     ;90F5: 81 10 
        BCS     Z9101                    ;90F7: 25 08 
        CMPA    #$17                     ;90F9: 81 17 
        BHI     Z9101                    ;90FB: 22 04 
        JSR     Z943B                    ;90FD: BD 94 3B 
        RTS                              ;9100: 39 
;------------------------------------------------------------------------
Z9101:	LDA     M80AE                    ;9101: 96 AE 
        CMPA    #$18                     ;9103: 81 18 
        BCS     Z910B                    ;9105: 25 04 
        JSR     Z95F0                    ;9107: BD 95 F0 
        RTS                              ;910A: 39 
;------------------------------------------------------------------------
Z910B:	BSR     Z9116                    ;910B: 8D 09 
        CMPA    #$0E                     ;910D: 81 0E 
        BEQ     Z90E9                    ;910F: 27 D8 
        CMPA    #$0F                     ;9111: 81 0F 
        BEQ     Z90E9                    ;9113: 27 D4 
        RTS                              ;9115: 39 
;------------------------------------------------------------------------
Z9116:	LDA     M80AE                    ;9116: 96 AE 
        CMPA    #$0B                     ;9118: 81 0B 
        BNE     Z9124                    ;911A: 26 08 
        JSR     ZAB90                    ;911C: BD AB 90 
        JSR     Z9249                    ;911F: BD 92 49 
        BRA     Z912B                    ;9122: 20 07 
;------------------------------------------------------------------------
Z9124:	CMPA    #$0C                     ;9124: 81 0C 
        BNE     Z913B                    ;9126: 26 13 
        JSR     Z9249                    ;9128: BD 92 49 
Z912B:	LDB     M808B                    ;912B: D6 8B 
        JSR     Z9D2D                    ;912D: BD 9D 2D 
        LDU     #ROM_LED_hexnum          ;9130: CE FB 4D 
        LDA     A,U                      ;9133: A6 C6 
        LDB     B,U                      ;9135: E6 C5 
        STD     M80B3                    ;9137: DD B3 
        CLRA                             ;9139: 4F 
        RTS                              ;913A: 39 
;------------------------------------------------------------------------
Z913B:	CMPA    #$0D                     ;913B: 81 0D 
        BNE     Z9148                    ;913D: 26 09 
        JSR     Z9249                    ;913F: BD 92 49 
Z9142:	INC     M8083                    ;9142: 0C 83 
        JSR     Z998B                    ;9144: BD 99 8B 
        RTS                              ;9147: 39 
;------------------------------------------------------------------------
Z9148:	CMPA    #$0E                     ;9148: 81 0E 
        BNE     Z9158                    ;914A: 26 0C 
        TST     M8083                    ;914C: 0D 83 
        BEQ     Z9142                    ;914E: 27 F2 
        STA     M8088                    ;9150: 97 88 
        LDA     #$01                     ;9152: 86 01 
        STA     M8084                    ;9154: 97 84 
        BRA     Z916A                    ;9156: 20 12 
;------------------------------------------------------------------------
Z9158:	CMPA    #$0F                     ;9158: 81 0F 
        LBNE    Z9198                    ;915A: 10 26 00 3A 
        TST     M8083                    ;915E: 0D 83 
        BEQ     Z9142                    ;9160: 27 E0 
        STA     M8088                    ;9162: 97 88 
        LDA     #$80                     ;9164: 86 80 
        STA     M8084                    ;9166: 97 84 
        BRA     Z916A                    ;9168: 20 00 
;------------------------------------------------------------------------
Z916A:	LDA     #$C8                     ;916A: 86 C8 
        STA     M8087                    ;916C: 97 87 
Z916E:	LDA     M8087                    ;916E: 96 87 
        STA     M8032                    ;9170: 97 32 
        JSR     Z998B                    ;9172: BD 99 8B 
        TST     M8208                    ;9175: 7D 82 08 
        BEQ     Z917C                    ;9178: 27 02 
        CLRA                             ;917A: 4F 
        RTS                              ;917B: 39 
;------------------------------------------------------------------------
Z917C:	JSR     Z9D4B                    ;917C: BD 9D 4B 
        LDA     M8088                    ;917F: 96 88 
        CMPA    M80AE                    ;9181: 91 AE 
        BNE     Z9197                    ;9183: 26 12 
        TST     M8032                    ;9185: 0D 32 
        BNE     Z917C                    ;9187: 26 F3 
        LDB     #$14                     ;9189: C6 14 
        CMPB    M8087                    ;918B: D1 87 
        BEQ     Z916E                    ;918D: 27 DF 
        LDB     M8087                    ;918F: D6 87 
        SUBB    #$3C                     ;9191: C0 3C 
        STB     M8087                    ;9193: D7 87 
        BRA     Z916E                    ;9195: 20 D7 
;------------------------------------------------------------------------
Z9197:	RTS                              ;9197: 39 
;------------------------------------------------------------------------
Z9198:	CMPA    #$0A                     ;9198: 81 0A 
        LBNE    Z9247                    ;919A: 10 26 00 A9 
        LDA     M8082                    ;919E: 96 82 
        CMPA    #$04                     ;91A0: 81 04 
        LBNE    Z923C                    ;91A2: 10 26 00 96 
        LDA     M8085                    ;91A6: 96 85 
        CMPA    #$03                     ;91A8: 81 03 
        BNE     Z91AD                    ;91AA: 26 01 
        RTS                              ;91AC: 39 
;------------------------------------------------------------------------
Z91AD:	CMPA    #$04                     ;91AD: 81 04 
        BNE     Z91BF                    ;91AF: 26 0E 
        LDA     M80E7                    ;91B1: 96 E7 
        CMPA    #$06                     ;91B3: 81 06 
        BNE     Z91BD                    ;91B5: 26 06 
        JSR     ZAB60                    ;91B7: BD AB 60 
        JSR     Z96F4                    ;91BA: BD 96 F4 
Z91BD:	CLRA                             ;91BD: 4F 
        RTS                              ;91BE: 39 
;------------------------------------------------------------------------
Z91BF:	CMPA    #$08                     ;91BF: 81 08 
        BNE     Z91D3                    ;91C1: 26 10 
        JSR     Z9FB4                    ;91C3: BD 9F B4 
        TST     M80BA                    ;91C6: 0D BA 
        BMI     Z91D0                    ;91C8: 2B 06 
        JSR     Z9249                    ;91CA: BD 92 49 
        JMP     Z912B                    ;91CD: 7E 91 2B 
;------------------------------------------------------------------------
Z91D0:	CLR     M80BA                    ;91D0: 0F BA 
        RTS                              ;91D2: 39 
;------------------------------------------------------------------------
Z91D3:	CMPA    #$01                     ;91D3: 81 01 
        BNE     Z91F1                    ;91D5: 26 1A 
        TST     M808C                    ;91D7: 0D 8C 
        BEQ     Z91F1                    ;91D9: 27 16 
        LDA     M8090                    ;91DB: 96 90 
        LDB     #$03                     ;91DD: C6 03 
        MUL                              ;91DF: 3D 
        PSHS    B                        ;91E0: 34 04 
        LDB     M808C                    ;91E2: D6 8C 
        DECB                             ;91E4: 5A 
        ADDB    ,S+                      ;91E5: EB E0 
        LDX     #table_10_20_00          ;91E7: 8E 82 09 
        LDA     M8091                    ;91EA: 96 91 
        ORB     A,X                      ;91EC: EA 86 
        JSR     ZA0F2                    ;91EE: BD A0 F2 
Z91F1:	JSR     Z9E83                    ;91F1: BD 9E 83 
        TST     word_8007_X              ;91F4: 7D 80 07 
        BEQ     Z9200                    ;91F7: 27 07 
        JSR     Z9249                    ;91F9: BD 92 49 
        JSR     Z9431                    ;91FC: BD 94 31 
        RTS                              ;91FF: 39 
;------------------------------------------------------------------------
Z9200:	LDB     M8085                    ;9200: D6 85 
        CMPB    #$01                     ;9202: C1 01 
        BNE     Z9234                    ;9204: 26 2E 
        LDA     M8091                    ;9206: 96 91 
        BEQ     Z920E                    ;9208: 27 04 
        CMPA    #$01                     ;920A: 81 01 
        BEQ     Z9224                    ;920C: 27 16 
Z920E:	LDA     M8090                    ;920E: 96 90 
        STA     M808F                    ;9210: 97 8F 
        LDB     #$24                     ;9212: C6 24 
        MUL                              ;9214: 3D 
        LDY     #tab_b4fe_step36         ;9215: 10 8E B4 FE 
        LEAY    D,Y                      ;9219: 31 AB 
        STY     vec_80a7                 ;921B: 10 9F A7 
        LDA     M8091                    ;921E: 96 91 
        CMPA    #$02                     ;9220: 81 02 
        BNE     Z9234                    ;9222: 26 10 
Z9224:	LDA     M8090                    ;9224: 96 90 
        STA     M808E                    ;9226: 97 8E 
        LDB     #$24                     ;9228: C6 24 
        MUL                              ;922A: 3D 
        LDY     #tab_b76f_step36         ;922B: 10 8E B7 6F 
        LEAY    D,Y                      ;922F: 31 AB 
        STY     vec_80a5                 ;9231: 10 9F A5 
Z9234:	JSR     Z8ECF                    ;9234: BD 8E CF 
        BSR     Z9249                    ;9237: 8D 10 
        LBRA    Z912B                    ;9239: 16 FE EF 
Z923C:	LDA     M8082                    ;923C: 96 82 
        CMPA    #$05                     ;923E: 81 05 
        BNE     Z9247                    ;9240: 26 05 
        BSR     Z9249                    ;9242: 8D 05 
        LBRA    Z912B                    ;9244: 16 FE E4 
Z9247:	CLRA                             ;9247: 4F 
        RTS                              ;9248: 39 
;------------------------------------------------------------------------
Z9249:	CLR     M8082                    ;9249: 0F 82 
        CLR     M8085                    ;924B: 0F 85 
        CLR     M8083                    ;924D: 0F 83 
        CLR     M8084                    ;924F: 0F 84 
        CLR     M8033                    ;9251: 0F 33 
        CLR     M808A                    ;9253: 0F 8A 
        CLR     M8089                    ;9255: 0F 89 
        RTS                              ;9257: 39 
;------------------------------------------------------------------------
Z9258:	LDY     #ROM_LED_hexnum          ;9258: 10 8E FB 4D 
        LDA     M8082                    ;925C: 96 82 
        CMPA    #$00                     ;925E: 81 00 
        LBNE    Z92A8                    ;9260: 10 26 00 44 
        TST     M80AE                    ;9264: 0D AE 
        BEQ     Z9284                    ;9266: 27 1C 
        TST     M80A4                    ;9268: 0D A4 
        BNE     Z9270                    ;926A: 26 04 
        LDB     #$1C                     ;926C: C6 1C 
        BRA     Z9272                    ;926E: 20 02 
;------------------------------------------------------------------------
Z9270:	LDB     #$7C                     ;9270: C6 7C 
Z9272:	LDA     M80AE                    ;9272: 96 AE 
        STA     M808D                    ;9274: 97 8D 
        LDA     A,Y                      ;9276: A6 A6 
        STD     M80B3                    ;9278: DD B3 
        JSR     Z9431                    ;927A: BD 94 31 
        CLR     M808A                    ;927D: 0F 8A 
        LDA     #$01                     ;927F: 86 01 
        STA     M8082                    ;9281: 97 82 
        RTS                              ;9283: 39 
;------------------------------------------------------------------------
Z9284:	TST     M80A4                    ;9284: 0D A4 
        BNE     Z9291                    ;9286: 26 09 
        LDB     M808F                    ;9288: D6 8F 
        INCB                             ;928A: 5C 
        LDB     B,Y                      ;928B: E6 A5 
        LDA     #$1C                     ;928D: 86 1C 
        BRA     Z9298                    ;928F: 20 07 
;------------------------------------------------------------------------
Z9291:	LDB     M808E                    ;9291: D6 8E 
        INCB                             ;9293: 5C 
        LDB     B,Y                      ;9294: E6 A5 
        LDA     #$7C                     ;9296: 86 7C 
Z9298:	STD     M80B3                    ;9298: DD B3 
        LDD     #word_8006_D             ;929A: CC 80 05 
        STA     M8083                    ;929D: 97 83 
        STB     M8082                    ;929F: D7 82 
        LDA     #$01                     ;92A1: 86 01 
        STA     M8089                    ;92A3: 97 89 
        CLR     M808A                    ;92A5: 0F 8A 
        RTS                              ;92A7: 39 
;------------------------------------------------------------------------
Z92A8:	CMPA    #$01                     ;92A8: 81 01 
        LBNE    Z9336                    ;92AA: 10 26 00 88 
        JSR     Z9249                    ;92AE: BD 92 49 
        LDB     M80AE                    ;92B1: D6 AE 
        LDB     B,Y                      ;92B3: E6 A5 
        STB     M80B4                    ;92B5: D7 B4 
        LDA     M808D                    ;92B7: 96 8D 
        LDB     #$0A                     ;92B9: C6 0A 
        MUL                              ;92BB: 3D 
        ADDB    M80AE                    ;92BC: DB AE 
        CMPB    #$0B                     ;92BE: C1 0B 
        BCS     Z92D0                    ;92C0: 25 0E 
        LDU     #data_9ff3_via_U         ;92C2: CE 9F F3 
        LDA     B,U                      ;92C5: A6 C5 
        BEQ     Z92D0                    ;92C7: 27 07 
        CMPA    #$FF                     ;92C9: 81 FF 
        BEQ     Z92D4                    ;92CB: 27 07 
        STB     M808B                    ;92CD: D7 8B 
        RTS                              ;92CF: 39 
;------------------------------------------------------------------------
Z92D0:	JSR     Z9431                    ;92D0: BD 94 31 
        RTS                              ;92D3: 39 
;------------------------------------------------------------------------
Z92D4:	STB     M808B                    ;92D4: D7 8B 
        TFR     B,A                      ;92D6: 1F 98 
        CMPA    #$0B                     ;92D8: 81 0B 
        BNE     Z92E4                    ;92DA: 26 08 
        CLRB                             ;92DC: 5F 
        STB     M8092                    ;92DD: D7 92 
        LDB     #$1C                     ;92DF: C6 1C 
        JMP     Z92FB                    ;92E1: 7E 92 FB 
;------------------------------------------------------------------------
Z92E4:	CMPA    #$0C                     ;92E4: 81 0C 
        BNE     Z92F1                    ;92E6: 26 09 
        LDB     #$01                     ;92E8: C6 01 
        STB     M8092                    ;92EA: D7 92 
        LDB     #$7C                     ;92EC: C6 7C 
        JMP     Z92FB                    ;92EE: 7E 92 FB 
;------------------------------------------------------------------------
Z92F1:	CMPA    #$0D                     ;92F1: 81 0D 
        BNE     Z9309                    ;92F3: 26 14 
        LDB     #$02                     ;92F5: C6 02 
        STB     M8092                    ;92F7: D7 92 
        LDB     #$EE                     ;92F9: C6 EE 
Z92FB:	LDA     #$B6                     ;92FB: 86 B6 
        STD     M80B3                    ;92FD: DD B3 
        LDA     #$02                     ;92FF: 86 02 
        STA     M8085                    ;9301: 97 85 
        STA     M8082                    ;9303: 97 82 
        JSR     Z9431                    ;9305: BD 94 31 
        RTS                              ;9308: 39 
;------------------------------------------------------------------------
Z9309:	CMPA    #$0E                     ;9309: 81 0E 
        BNE     Z931D                    ;930B: 26 10 
        LDD     #b6ce_via_D              ;930D: CC B6 CE 
        STD     M80B3                    ;9310: DD B3 
        JSR     Z9431                    ;9312: BD 94 31 
        LDD     #M0904                   ;9315: CC 09 04 
        STA     M8085                    ;9318: 97 85 
        STB     M8082                    ;931A: D7 82 
        RTS                              ;931C: 39 
;------------------------------------------------------------------------
Z931D:	CMPA    #$0F                     ;931D: 81 0F 
        BNE     Z9325                    ;931F: 26 04 
        JSR     Z9F9A                    ;9321: BD 9F 9A 
        RTS                              ;9324: 39 
;------------------------------------------------------------------------
Z9325:	CMPA    #$10                     ;9325: 81 10 
        BNE     Z932D                    ;9327: 26 04 
        JSR     Z9F9A                    ;9329: BD 9F 9A 
        RTS                              ;932C: 39 
;------------------------------------------------------------------------
Z932D:	LDD     #M2A3A                   ;932D: CC 2A 3A 
        STD     M80B3                    ;9330: DD B3 
        JSR     Z9431                    ;9332: BD 94 31 
        RTS                              ;9335: 39 
;------------------------------------------------------------------------
Z9336:	CMPA    #$02                     ;9336: 81 02 
        BNE     Z934A                    ;9338: 26 10 
        LDA     M80AE                    ;933A: 96 AE 
        BNE     Z9345                    ;933C: 26 07 
        LDA     M8091                    ;933E: 96 91 
        CMPA    #$02                     ;9340: 81 02 
        BEQ     Z9357                    ;9342: 27 13 
        RTS                              ;9344: 39 
;------------------------------------------------------------------------
Z9345:	CMPA    #$03                     ;9345: 81 03 
        BLS     Z9357                    ;9347: 23 0E 
        RTS                              ;9349: 39 
;------------------------------------------------------------------------
Z934A:	CMPA    #$03                     ;934A: 81 03 
        BNE     Z937C                    ;934C: 26 2E 
        LDA     M80AE                    ;934E: 96 AE 
        BEQ     Z9356                    ;9350: 27 04 
        CMPA    #$09                     ;9352: 81 09 
        BCS     Z9357                    ;9354: 25 01 
Z9356:	RTS                              ;9356: 39 
;------------------------------------------------------------------------
Z9357:	LDA     M8085                    ;9357: 96 85 
        CMPA    #$01                     ;9359: 81 01 
        BEQ     Z9361                    ;935B: 27 04 
        CMPA    #$05                     ;935D: 81 05 
        BNE     Z9365                    ;935F: 26 04 
Z9361:	LDB     #$10                     ;9361: C6 10 
        BRA     Z9367                    ;9363: 20 02 
;------------------------------------------------------------------------
Z9365:	LDB     #$05                     ;9365: C6 05 
Z9367:	LDA     B,Y                      ;9367: A6 A5 
        LDB     M80AE                    ;9369: D6 AE 
        STB     M808C                    ;936B: D7 8C 
        LDB     B,Y                      ;936D: E6 A5 
        STD     M80B3                    ;936F: DD B3 
        CLR     M8090                    ;9371: 0F 90 
        CLR     M808A                    ;9373: 0F 8A 
        CLR     M8089                    ;9375: 0F 89 
        LDA     #$04                     ;9377: 86 04 
        STA     M8082                    ;9379: 97 82 
        RTS                              ;937B: 39 
;------------------------------------------------------------------------
Z937C:	CMPA    #$04                     ;937C: 81 04 
        BNE     Z93A0                    ;937E: 26 20 
        LDA     M80AE                    ;9380: 96 AE 
        CMPA    #$01                     ;9382: 81 01 
        BCS     Z939F                    ;9384: 25 19 
        CMPA    #$04                     ;9386: 81 04 
        BHI     Z939F                    ;9388: 22 15 
        LDB     M8085                    ;938A: D6 85 
        CMPB    #$01                     ;938C: C1 01 
        BNE     Z939F                    ;938E: 26 0F 
        TST     M808C                    ;9390: 0D 8C 
        BEQ     Z939F                    ;9392: 27 0B 
        LDB     A,Y                      ;9394: E6 A6 
        DECA                             ;9396: 4A 
        STA     M8090                    ;9397: 97 90 
        LDA     M808C                    ;9399: 96 8C 
        LDA     A,Y                      ;939B: A6 A6 
        STD     M80B3                    ;939D: DD B3 
Z939F:	RTS                              ;939F: 39 
;------------------------------------------------------------------------
Z93A0:	CMPA    #$05                     ;93A0: 81 05 
        LBNE    Z9412                    ;93A2: 10 26 00 6C 
        TST     M80AE                    ;93A6: 0D AE 
        BNE     Z93B8                    ;93A8: 26 0E 
        TST     M80A4                    ;93AA: 0D A4 
        BEQ     Z93B3                    ;93AC: 27 05 
        CLR     M80A4                    ;93AE: 0F A4 
        LBRA    Z9284                    ;93B0: 16 FE D1 
Z93B3:	INC     M80A4                    ;93B3: 0C A4 
        LBRA    Z9284                    ;93B5: 16 FE CC 
Z93B8:	LDA     M80AE                    ;93B8: 96 AE 
        CMPA    #$01                     ;93BA: 81 01 
        BCS     Z9412                    ;93BC: 25 54 
        CMPA    #$04                     ;93BE: 81 04 
        BHI     Z9412                    ;93C0: 22 50 
        LDB     A,Y                      ;93C2: E6 A6 
        STB     M80B4                    ;93C4: D7 B4 
        DECA                             ;93C6: 4A 
        JSR     Z9249                    ;93C7: BD 92 49 
        LDB     #$80                     ;93CA: C6 80 
        STB     M8083                    ;93CC: D7 83 
        TST     word_8016_X              ;93CE: 0D 16 
        BNE     Z93D6                    ;93D0: 26 04 
        TST     M80A4                    ;93D2: 0D A4 
        BEQ     Z93E6                    ;93D4: 27 10 
Z93D6:	STA     M808E                    ;93D6: 97 8E 
        LDB     #$24                     ;93D8: C6 24 
        MUL                              ;93DA: 3D 
        ADDD    #tab_b76f_step36         ;93DB: C3 B7 6F 
        STD     vec_80a5                 ;93DE: DD A5 
        TST     word_8016_X              ;93E0: 0D 16 
        BEQ     Z93F0                    ;93E2: 27 0C 
        LDA     M808E                    ;93E4: 96 8E 
Z93E6:	STA     M808F                    ;93E6: 97 8F 
        LDB     #$24                     ;93E8: C6 24 
        MUL                              ;93EA: 3D 
        ADDD    #tab_b4fe_step36         ;93EB: C3 B4 FE 
        STD     vec_80a7                 ;93EE: DD A7 
Z93F0:	JSR     Z8ECF                    ;93F0: BD 8E CF 
        ORCC    #$50                     ;93F3: 1A 50 
        JSR     task_handler_875e        ;93F5: BD 87 5E 
        ANDCC   #$AF                     ;93F8: 1C AF 
        LDB     M80AE                    ;93FA: D6 AE 
        DECB                             ;93FC: 5A 
        TST     word_8016_X              ;93FD: 0D 16 
        BEQ     Z9405                    ;93FF: 27 04 
        ADDB    #$0C                     ;9401: CB 0C 
        BRA     Z940F                    ;9403: 20 0A 
;------------------------------------------------------------------------
Z9405:	TST     M80A4                    ;9405: 0D A4 
        BNE     Z940D                    ;9407: 26 04 
        ADDB    #$1C                     ;9409: CB 1C 
        BRA     Z940F                    ;940B: 20 02 
;------------------------------------------------------------------------
Z940D:	ADDB    #$2C                     ;940D: CB 2C 
Z940F:	JSR     ZA0F2                    ;940F: BD A0 F2 
Z9412:	CMPA    #$06                     ;9412: 81 06 
        BNE     Z9430                    ;9414: 26 1A 
        LDA     M80AE                    ;9416: 96 AE 
        CMPA    #$01                     ;9418: 81 01 
        BCS     Z9430                    ;941A: 25 14 
        CMPA    #$04                     ;941C: 81 04 
        BHI     Z9430                    ;941E: 22 10 
        LDB     A,Y                      ;9420: E6 A6 
        STB     M80B4                    ;9422: D7 B4 
        DECA                             ;9424: 4A 
        STA     M80B7                    ;9425: 97 B7 
        LDD     #M0804                   ;9427: CC 08 04 
        STA     M8085                    ;942A: 97 85 
        STB     M8082                    ;942C: D7 82 
        CLR     M8089                    ;942E: 0F 89 
Z9430:	RTS                              ;9430: 39 
;------------------------------------------------------------------------
Z9431:	LDD     #M0180                   ;9431: CC 01 80 
        STA     M808A                    ;9434: 97 8A 
        STA     M8089                    ;9436: 97 89 
        STB     M8083                    ;9438: D7 83 
        RTS                              ;943A: 39 
;------------------------------------------------------------------------
Z943B:	LDU     #ROM_LED_hexnum          ;943B: CE FB 4D 
        LDA     M80AE                    ;943E: 96 AE 
        CMPA    #$10                     ;9440: 81 10 
        BEQ     Z9448                    ;9442: 27 04 
        CMPA    #$11                     ;9444: 81 11 
        BNE     Z949B                    ;9446: 26 53 
Z9448:	LDA     #$01                     ;9448: 86 01 
        STA     M8085                    ;944A: 97 85 
        LDA     M8082                    ;944C: 96 82 
        BNE     Z9470                    ;944E: 26 20 
        LDA     #$02                     ;9450: 86 02 
        STA     M8082                    ;9452: 97 82 
        LDA     #$1C                     ;9454: 86 1C 
        LDB     M80AE                    ;9456: D6 AE 
        CMPB    #$10                     ;9458: C1 10 
        BEQ     Z9465                    ;945A: 27 09 
        LDB     #$1C                     ;945C: C6 1C 
        STD     M80B3                    ;945E: DD B3 
        CLR     M8091                    ;9460: 0F 91 
        JMP     Z95DD                    ;9462: 7E 95 DD 
;------------------------------------------------------------------------
Z9465:	LDB     #$7C                     ;9465: C6 7C 
        STD     M80B3                    ;9467: DD B3 
        LDA     #$01                     ;9469: 86 01 
        STA     M8091                    ;946B: 97 91 
        JMP     Z95DD                    ;946D: 7E 95 DD 
;------------------------------------------------------------------------
Z9470:	LDA     M8091                    ;9470: 96 91 
        CMPA    #$02                     ;9472: 81 02 
        BNE     Z9477                    ;9474: 26 01 
        RTS                              ;9476: 39 
;------------------------------------------------------------------------
Z9477:	LDA     M8082                    ;9477: 96 82 
        CMPA    #$02                     ;9479: 81 02 
        BNE     Z949B                    ;947B: 26 1E 
        LDA     M80AE                    ;947D: 96 AE 
        CMPA    #$11                     ;947F: 81 11 
        BEQ     Z948A                    ;9481: 27 07 
        LDA     M8091                    ;9483: 96 91 
        CMPA    #$01                     ;9485: 81 01 
        BNE     Z948F                    ;9487: 26 06 
        RTS                              ;9489: 39 
;------------------------------------------------------------------------
Z948A:	LDA     M8091                    ;948A: 96 91 
        BNE     Z948F                    ;948C: 26 01 
        RTS                              ;948E: 39 
;------------------------------------------------------------------------
Z948F:	LDD     #M1CEE                   ;948F: CC 1C EE 
        STD     M80B3                    ;9492: DD B3 
        LDA     #$02                     ;9494: 86 02 
        STA     M8091                    ;9496: 97 91 
        JMP     Z95DD                    ;9498: 7E 95 DD 
;------------------------------------------------------------------------
Z949B:	LDA     M80AE                    ;949B: 96 AE 
        CMPA    #$12                     ;949D: 81 12 
        BEQ     Z94A7                    ;949F: 27 06 
        CMPA    #$13                     ;94A1: 81 13 
        LBNE    Z952D                    ;94A3: 10 26 00 86 
Z94A7:	LDA     M80AE                    ;94A7: 96 AE 
        CMPA    #$12                     ;94A9: 81 12 
        BNE     Z94B5                    ;94AB: 26 08 
        LDB     #$7C                     ;94AD: C6 7C 
        LDA     #$01                     ;94AF: 86 01 
        STA     M80A4                    ;94B1: 97 A4 
        BRA     Z94B9                    ;94B3: 20 04 
;------------------------------------------------------------------------
Z94B5:	LDB     #$1C                     ;94B5: C6 1C 
        CLR     M80A4                    ;94B7: 0F A4 
Z94B9:	LDA     #$B6                     ;94B9: 86 B6 
        STD     M80B3                    ;94BB: DD B3 
        LDA     #$03                     ;94BD: 86 03 
        STA     M8085                    ;94BF: 97 85 
        LDD     #M03E8                   ;94C1: CC 03 E8 
        STD     M8034                    ;94C4: DD 34 
        JSR     Z9431                    ;94C6: BD 94 31 
Z94C9:	JSR     Z9DD7                    ;94C9: BD 9D D7 
        LDD     M8034                    ;94CC: DC 34 
        BEQ     Z94D2                    ;94CE: 27 02 
        BRA     Z94C9                    ;94D0: 20 F7 
;------------------------------------------------------------------------
Z94D2:	JSR     Z9F60                    ;94D2: BD 9F 60 
        JSR     Z9700                    ;94D5: BD 97 00 
Z94D8:	JSR     Z974E                    ;94D8: BD 97 4E 
        LDB     #$1F                     ;94DB: C6 1F 
        STB     VIA_dr_a                 ;94DD: F7 E2 01 
        EXG     A,B                      ;94E0: 1E 89 
        EXG     A,B                      ;94E2: 1E 89 
        LDB     VIA_dr_a                 ;94E4: F6 E2 01 
        ANDB    #$C0                     ;94E7: C4 C0 
        CMPB    #$40                     ;94E9: C1 40 
        BNE     Z94F3                    ;94EB: 26 06 
        LDA     #$02                     ;94ED: 86 02 
        STA     M8093                    ;94EF: 97 93 
        BRA     Z9501                    ;94F1: 20 0E 
;------------------------------------------------------------------------
Z94F3:	CMPB    #$80                     ;94F3: C1 80 
        BEQ     Z94FC                    ;94F5: 27 05 
        STA     VIA_dr_a                 ;94F7: B7 E2 01 
        BRA     Z94D8                    ;94FA: 20 DC 
;------------------------------------------------------------------------
Z94FC:	JSR     Z9795                    ;94FC: BD 97 95 
        STA     M8093                    ;94FF: 97 93 
Z9501:	JSR     Z9F6F                    ;9501: BD 9F 6F 
        JSR     Z9249                    ;9504: BD 92 49 
        LDU     #ROM_LED_hexnum          ;9507: CE FB 4D 
        LDA     M8093                    ;950A: 96 93 
        BEQ     Z951B                    ;950C: 27 0D 
        CMPA    #$01                     ;950E: 81 01 
        BNE     Z9525                    ;9510: 26 13 
        LDD     #M2AB6                   ;9512: CC 2A B6 
        STD     M80B3                    ;9515: DD B3 
        JSR     Z9431                    ;9517: BD 94 31 
        RTS                              ;951A: 39 
;------------------------------------------------------------------------
Z951B:	LDD     #b68e_via_D              ;951B: CC B6 8E 
        STD     M80B3                    ;951E: DD B3 
        LDA     #$80                     ;9520: 86 80 
        STA     M8083                    ;9522: 97 83 
        RTS                              ;9524: 39 
;------------------------------------------------------------------------
Z9525:	LDA     #$0B                     ;9525: 86 0B 
        STA     M80AE                    ;9527: 97 AE 
        JSR     Z9116                    ;9529: BD 91 16 
        RTS                              ;952C: 39 
;------------------------------------------------------------------------
Z952D:	LDA     M80AE                    ;952D: 96 AE 
        CMPA    #$14                     ;952F: 81 14 
        LBCS    Z95E0                    ;9531: 10 25 00 AB 
        CMPA    #$17                     ;9535: 81 17 
        LBHI    Z95E0                    ;9537: 10 22 00 A5 
        LDA     M80AE                    ;953B: 96 AE 
        CMPA    #$15                     ;953D: 81 15 
        BNE     Z957C                    ;953F: 26 3B 
        LDA     #$04                     ;9541: 86 04 
        STA     M8085                    ;9543: 97 85 
        LDA     M80E7                    ;9545: 96 E7 
        CMPA    #$00                     ;9547: 81 00 
        BNE     Z9551                    ;9549: 26 06 
        JSR     Z95E1                    ;954B: BD 95 E1 
        RTS                              ;954E: 39 
;------------------------------------------------------------------------
        BRA     Z9573                    ;954F: 20 22 
;------------------------------------------------------------------------
Z9551:	CMPA    #$02                     ;9551: 81 02 
        BNE     Z955E                    ;9553: 26 09 
        JSR     ZAB90                    ;9555: BD AB 90 
        JSR     Z95E1                    ;9558: BD 95 E1 
        RTS                              ;955B: 39 
;------------------------------------------------------------------------
        BRA     Z9573                    ;955C: 20 15 
;------------------------------------------------------------------------
Z955E:	CMPA    #$04                     ;955E: 81 04 
        BNE     Z9573                    ;9560: 26 11 
        JSR     ZAB80                    ;9562: BD AB 80 
        LDD     #M3A7A                   ;9565: CC 3A 7A 
        STD     M80B3                    ;9568: DD B3 
        LDA     #$80                     ;956A: 86 80 
        STA     M8083                    ;956C: 97 83 
        CLR     M808A                    ;956E: 0F 8A 
        CLR     M8089                    ;9570: 0F 89 
        RTS                              ;9572: 39 
;------------------------------------------------------------------------
Z9573:	JSR     ZAB90                    ;9573: BD AB 90 
        JSR     Z95E1                    ;9576: BD 95 E1 
        RTS                              ;9579: 39 
;------------------------------------------------------------------------
        BRA     Z95D9                    ;957A: 20 5D 
;------------------------------------------------------------------------
Z957C:	CMPA    #$14                     ;957C: 81 14 
        BNE     Z95AF                    ;957E: 26 2F 
        LDA     #$04                     ;9580: 86 04 
        STA     M8085                    ;9582: 97 85 
        LDA     M80E7                    ;9584: 96 E7 
        CMPA    #$04                     ;9586: 81 04 
        BNE     Z9598                    ;9588: 26 0E 
        JSR     ZAB53                    ;958A: BD AB 53 
        LDA     #$04                     ;958D: 86 04 
        STA     M8082                    ;958F: 97 82 
        CLR     M808A                    ;9591: 0F 8A 
        CLR     M8089                    ;9593: 0F 89 
        RTS                              ;9595: 39 
;------------------------------------------------------------------------
        BRA     Z95A1                    ;9596: 20 09 
;------------------------------------------------------------------------
Z9598:	CMPA    #$00                     ;9598: 81 00 
        BNE     Z95A1                    ;959A: 26 05 
        JSR     ZAB4E                    ;959C: BD AB 4E 
        BRA     Z95A7                    ;959F: 20 06 
;------------------------------------------------------------------------
Z95A1:	JSR     ZAB90                    ;95A1: BD AB 90 
        JSR     ZAB4E                    ;95A4: BD AB 4E 
Z95A7:	LDB     #$04                     ;95A7: C6 04 
        STB     M8082                    ;95A9: D7 82 
        LDA     #$0A                     ;95AB: 86 0A 
        BRA     Z95D9                    ;95AD: 20 2A 
;------------------------------------------------------------------------
Z95AF:	CMPA    #$16                     ;95AF: 81 16 
        BNE     Z95BF                    ;95B1: 26 0C 
        LDA     #$03                     ;95B3: 86 03 
        STA     M8082                    ;95B5: 97 82 
        LDA     #$05                     ;95B7: 86 05 
        STA     M8085                    ;95B9: 97 85 
        LDA     #$1C                     ;95BB: 86 1C 
        BRA     Z95D9                    ;95BD: 20 1A 
;------------------------------------------------------------------------
Z95BF:	CMPA    #$17                     ;95BF: 81 17 
        BNE     Z95D9                    ;95C1: 26 16 
        TST     M80E4                    ;95C3: 0D E4 
        BEQ     Z95CF                    ;95C5: 27 08 
        LDA     #$02                     ;95C7: 86 02 
        STA     M8082                    ;95C9: 97 82 
        LDA     #$07                     ;95CB: 86 07 
        BRA     Z95D5                    ;95CD: 20 06 
;------------------------------------------------------------------------
Z95CF:	LDB     #$03                     ;95CF: C6 03 
        STB     M8082                    ;95D1: D7 82 
        LDA     #$06                     ;95D3: 86 06 
Z95D5:	STA     M8085                    ;95D5: 97 85 
        LDA     #$B6                     ;95D7: 86 B6 
Z95D9:	LDB     #$B6                     ;95D9: C6 B6 
        STD     M80B3                    ;95DB: DD B3 
Z95DD:	JSR     Z9431                    ;95DD: BD 94 31 
Z95E0:	RTS                              ;95E0: 39 
;------------------------------------------------------------------------
Z95E1:	JSR     ZAB43                    ;95E1: BD AB 43 
Z95E4:	LDA     #$57                     ;95E4: 86 57 
        STA     M808B                    ;95E6: 97 8B 
        LDA     #$0D                     ;95E8: 86 0D 
        STA     M80AE                    ;95EA: 97 AE 
        JSR     Z9116                    ;95EC: BD 91 16 
        RTS                              ;95EF: 39 
;------------------------------------------------------------------------
Z95F0:	LDA     M80AE                    ;95F0: 96 AE 
        CMPA    #$19                     ;95F2: 81 19 
        BNE     Z95FF                    ;95F4: 26 09 
        JSR     Z9249                    ;95F6: BD 92 49 
        JSR     Z96F4                    ;95F9: BD 96 F4 
        LBRA    Z96F3                    ;95FC: 16 00 F4 
Z95FF:	CMPA    #$1A                     ;95FF: 81 1A 
        LBNE    Z960F                    ;9601: 10 26 00 0A 
        LDA     #$0C                     ;9605: 86 0C 
        STA     M80AE                    ;9607: 97 AE 
        JSR     Z9116                    ;9609: BD 91 16 
        LBRA    Z96F3                    ;960C: 16 00 E4 
Z960F:	CMPA    #$1B                     ;960F: 81 1B 
        LBNE    Z964C                    ;9611: 10 26 00 37 
        LDA     M80E7                    ;9615: 96 E7 
        CMPA    #$00                     ;9617: 81 00 
        BNE     Z961F                    ;9619: 26 04 
        JSR     Z95E1                    ;961B: BD 95 E1 
        RTS                              ;961E: 39 
;------------------------------------------------------------------------
Z961F:	CMPA    #$06                     ;961F: 81 06 
        BNE     Z962D                    ;9621: 26 0A 
        JSR     ZAB60                    ;9623: BD AB 60 
        JSR     Z9249                    ;9626: BD 92 49 
        JSR     Z96F4                    ;9629: BD 96 F4 
        RTS                              ;962C: 39 
;------------------------------------------------------------------------
Z962D:	CMPA    #$08                     ;962D: 81 08 
        BNE     Z9644                    ;962F: 26 13 
        JSR     ZAB90                    ;9631: BD AB 90 
        LDA     word_8027_X              ;9634: 96 27 
        BEQ     Z963C                    ;9636: 27 04 
        JSR     Z95E1                    ;9638: BD 95 E1 
        RTS                              ;963B: 39 
;------------------------------------------------------------------------
Z963C:	LDA     #$0C                     ;963C: 86 0C 
        STA     M80AE                    ;963E: 97 AE 
        JSR     Z9116                    ;9640: BD 91 16 
        RTS                              ;9643: 39 
;------------------------------------------------------------------------
Z9644:	JSR     ZAB90                    ;9644: BD AB 90 
        BRA     Z963C                    ;9647: 20 F3 
;------------------------------------------------------------------------
        LBRA    Z96F3                    ;9649: 16 00 A7 
Z964C:	CMPA    #$1C                     ;964C: 81 1C 
        LBNE    Z9662                    ;964E: 10 26 00 10 
        LDA     M80E7                    ;9652: 96 E7 
        CMPA    #$00                     ;9654: 81 00 
        BEQ     Z965C                    ;9656: 27 04 
        CMPA    #$02                     ;9658: 81 02 
        BNE     Z965F                    ;965A: 26 03 
Z965C:	JSR     Z95E1                    ;965C: BD 95 E1 
Z965F:	LBRA    Z96F3                    ;965F: 16 00 91 
Z9662:	CMPA    #$1D                     ;9662: 81 1D 
        LBNE    Z9676                    ;9664: 10 26 00 0E 
        LDA     M80E7                    ;9668: 96 E7 
        CMPA    #$00                     ;966A: 81 00 
        BNE     Z9674                    ;966C: 26 06 
        JSR     ZAB45                    ;966E: BD AB 45 
        JSR     Z95E4                    ;9671: BD 95 E4 
Z9674:	BRA     Z96F3                    ;9674: 20 7D 
;------------------------------------------------------------------------
Z9676:	CMPA    #$1E                     ;9676: 81 1E 
        BNE     Z9683                    ;9678: 26 09 
        LDA     #$0B                     ;967A: 86 0B 
        STA     M80AE                    ;967C: 97 AE 
        JSR     Z9116                    ;967E: BD 91 16 
        BRA     Z96F3                    ;9681: 20 70 
;------------------------------------------------------------------------
Z9683:	TSTA                             ;9683: 4D 
        BMI     Z9687                    ;9684: 2B 01 
        RTS                              ;9686: 39 
;------------------------------------------------------------------------
Z9687:	ANDA    #$3F                     ;9687: 84 3F 
        TFR     A,B                      ;9689: 1F 89 
        LSRA                             ;968B: 44 
        LSRA                             ;968C: 44 
        LSRA                             ;968D: 44 
        LSRA                             ;968E: 44 
        LDX     #table_02_00_01          ;968F: 8E 82 0C 
        LDA     A,X                      ;9692: A6 86 
        STA     M8091                    ;9694: 97 91 
        ANDB    #$0F                     ;9696: C4 0F 
        LDX     #table_04_08_0c|05_09_0d|06_0a_0e|07_0b_0f|80_81_82_83 ;9698: 8E 82 0F 
        LDB     B,X                      ;969B: E6 85 
        BMI     Z96C5                    ;969D: 2B 26 
        TFR     B,A                      ;969F: 1F 98 
        ANDA    #$03                     ;96A1: 84 03 
        STA     M8090                    ;96A3: 97 90 
        LSRB                             ;96A5: 54 
        LSRB                             ;96A6: 54 
        STB     M808C                    ;96A7: D7 8C 
        LDD     #M0104                   ;96A9: CC 01 04 
        STA     M8085                    ;96AC: 97 85 
        STB     M8082                    ;96AE: D7 82 
        LDA     #$0A                     ;96B0: 86 0A 
        STA     M80AE                    ;96B2: 97 AE 
Z96B4:	LDX     #word_8023_X             ;96B4: 8E 80 23 
        LDA     ,X                       ;96B7: A6 84 
        PSHS    X,A                      ;96B9: 34 12 
        CLR     ,X                       ;96BB: 6F 84 
        JSR     Z90E9                    ;96BD: BD 90 E9 
        PULS    X,A                      ;96C0: 35 12 
        STA     ,X                       ;96C2: A7 84 
        RTS                              ;96C4: 39 
;------------------------------------------------------------------------
Z96C5:	ANDB    #$03                     ;96C5: C4 03 
        INCB                             ;96C7: 5C 
        STB     M80AE                    ;96C8: D7 AE 
        LDA     word_8016_X              ;96CA: 96 16 
        PSHS    A                        ;96CC: 34 02 
        LDA     M8091                    ;96CE: 96 91 
        BNE     Z96D8                    ;96D0: 26 06 
        CLR     M80A4                    ;96D2: 0F A4 
        CLR     word_8016_X              ;96D4: 0F 16 
        BRA     Z96E6                    ;96D6: 20 0E 
;------------------------------------------------------------------------
Z96D8:	CMPA    #$01                     ;96D8: 81 01 
        BNE     Z96E2                    ;96DA: 26 06 
        STA     M80A4                    ;96DC: 97 A4 
        CLR     word_8016_X              ;96DE: 0F 16 
        BRA     Z96E6                    ;96E0: 20 04 
;------------------------------------------------------------------------
Z96E2:	LDA     #$01                     ;96E2: 86 01 
        STA     word_8016_X              ;96E4: 97 16 
Z96E6:	LDA     #$05                     ;96E6: 86 05 
        STA     M8082                    ;96E8: 97 82 
        CLR     M80B3                    ;96EA: 0F B3 
        JSR     Z96B4                    ;96EC: BD 96 B4 
        PULS    A                        ;96EF: 35 02 
        STA     word_8016_X              ;96F1: 97 16 
Z96F3:	RTS                              ;96F3: 39 
;------------------------------------------------------------------------
Z96F4:	LDD     #data_b60a_via_D         ;96F4: CC B6 0A 
        STD     M80B3                    ;96F7: DD B3 
        LDA     #$80                     ;96F9: 86 80 
        STA     M8083                    ;96FB: 97 83 
        RTS                              ;96FD: 39 
;------------------------------------------------------------------------
M96FE:	STU     M181A                    ;96FE: FF 18 1A 
        NEGB                             ;9701: 50 
        LDA     #$14                     ;9702: 86 14 
        STA     VIA_dr_b                 ;9704: B7 E2 00 
        JSR     ZAE17                    ;9707: BD AE 17 
        LDX     #VCF_base                ;970A: 8E E4 1F 
        LDA     word_8018_X              ;970D: 96 18 
        ADDA    MB283                    ;970F: BB B2 83 
        ADDA    #$5B                     ;9712: 8B 5B 
        BCC     Z9718                    ;9714: 24 02 
        LDA     #$FF                     ;9716: 86 FF 
Z9718:	STA     M96FE                    ;9718: B7 96 FE 
        LDY     #M03E8                   ;971B: 10 8E 03 E8 
        JSR     ROM_countdown            ;971F: BD F0 A7 
        LDB     word_8019_X              ;9722: D6 19 
        BNE     Z972B                    ;9724: 26 05 
        LDA     #$10                     ;9726: 86 10 
        STA     VIA_dr_b                 ;9728: B7 E2 00 
Z972B:	JSR     Z9858                    ;972B: BD 98 58 
        CLRB                             ;972E: 5F 
        LDA     word_8017_X              ;972F: 96 17 
        DECA                             ;9731: 4A 
        ASLA                             ;9732: 48 
        STD     VIA_t1_lsb               ;9733: FD E2 06 
        LDD     #M4CC0                   ;9736: CC 4C C0 
        STA     VIA_aux                  ;9739: B7 E2 0B 
        STB     VIA_ier                  ;973C: F7 E2 0E 
        BSR     Z9742                    ;973F: 8D 01 
        RTS                              ;9741: 39 
;------------------------------------------------------------------------
Z9742:	LDD     M96FE                    ;9742: FC 96 FE 
        STB     ,X                       ;9745: E7 84 
        STB     -$10,X                   ;9747: E7 10 
        STA     ,X                       ;9749: A7 84 
        STA     -$08,X                   ;974B: A7 18 
        RTS                              ;974D: 39 
;------------------------------------------------------------------------
Z974E:	BSR     Z9742                    ;974E: 8D F2 
        LDU     #DOC_adc                 ;9750: CE EC E2 
        LDB     ,U                       ;9753: E6 C4 
        LDA     #$14                     ;9755: 86 14 
        CLR     M8098                    ;9757: 0F 98 
        CLR     M8099                    ;9759: 0F 99 
        CLR     M809A                    ;975B: 0F 9A 
Z975D:	BSR     Z977B                    ;975D: 8D 1C 
        DECA                             ;975F: 4A 
        BNE     Z975D                    ;9760: 26 FB 
        LDB     #$03                     ;9762: C6 03 
        CMPB    M809A                    ;9764: D1 9A 
        BLS     Z977A                    ;9766: 23 12 
        CMPB    M8099                    ;9768: D1 99 
        BLS     Z9778                    ;976A: 23 0C 
        CMPB    M8098                    ;976C: D1 98 
        BLS     Z9774                    ;976E: 23 04 
        LDA     #$07                     ;9770: 86 07 
        BRA     Z9776                    ;9772: 20 02 
;------------------------------------------------------------------------
Z9774:	LDA     #$03                     ;9774: 86 03 
Z9776:	BRA     Z977A                    ;9776: 20 02 
;------------------------------------------------------------------------
Z9778:	LDA     #$06                     ;9778: 86 06 
Z977A:	RTS                              ;977A: 39 
;------------------------------------------------------------------------
Z977B:	LDB     ,U                       ;977B: E6 C4 
        ADDB    #$80                     ;977D: CB 80 
        BPL     Z9782                    ;977F: 2A 01 
        NEGB                             ;9781: 50 
Z9782:	CMPB    #$7F                     ;9782: C1 7F 
        BCS     Z9788                    ;9784: 25 02 
        INC     M809A                    ;9786: 0C 9A 
Z9788:	CMPB    word_801a_X              ;9788: D1 1A 
        BCS     Z978E                    ;978A: 25 02 
        INC     M8099                    ;978C: 0C 99 
Z978E:	CMPB    #$08                     ;978E: C1 08 
        BCS     Z9794                    ;9790: 25 02 
        INC     M8098                    ;9792: 0C 98 
Z9794:	RTS                              ;9794: 39 
;------------------------------------------------------------------------
Z9795:	LDA     word_801b_X              ;9795: 96 1B 
        BNE     Z97D4                    ;9797: 26 3B 
        LDA     M80A4                    ;9799: 96 A4 
        BNE     Z97A9                    ;979B: 26 0C 
        CLR     vector_80aa_X            ;979D: 0F AA 
        JSR     Z9A85                    ;979F: BD 9A 85 
        LDX     #M03FA                   ;97A2: 8E 03 FA 
        LDA     #$1E                     ;97A5: 86 1E 
        BRA     Z97B3                    ;97A7: 20 0A 
;------------------------------------------------------------------------
Z97A9:	CLR     vector_80a9_X            ;97A9: 0F A9 
        JSR     Z9A85                    ;97AB: BD 9A 85 
        LDX     #M038E                   ;97AE: 8E 03 8E 
        LDA     #$3C                     ;97B1: 86 3C 
Z97B3:	CLR     $0A,U                    ;97B3: 6F 4A 
        CLR     $0B,U                    ;97B5: 6F 4B 
        LDB     #$08                     ;97B7: C6 08 
Z97B9:	PSHS    Y,X,D                    ;97B9: 34 36 
        STX     $09,Y                    ;97BB: AF 29 
        STA     $0E,Y                    ;97BD: A7 2E 
        CLR     $0F,Y                    ;97BF: 6F 2F 
        CLR     $08,Y                    ;97C1: 6F 28 
        LDD     #ROM_word_d15            ;97C3: CC FF 10 
        JSR     Z8F11                    ;97C6: BD 8F 11 
        PULS    Y,X,D                    ;97C9: 35 36 
        LEAY    $18,Y                    ;97CB: 31 A8 18 
        DECB                             ;97CE: 5A 
        BNE     Z97B9                    ;97CF: 26 E8 
        JSR     Z8ECF                    ;97D1: BD 8E CF 
Z97D4:	JSR     Z986C                    ;97D4: BD 98 6C 
        BMI     Z97ED                    ;97D7: 2B 14 
        LDA     M809B                    ;97D9: 96 9B 
        STA     VIA_dr_b                 ;97DB: B7 E2 00 
        TSTB                             ;97DE: 5D 
        BPL     Z97EA                    ;97DF: 2A 09 
        ANDB    #$7F                     ;97E1: C4 7F 
        STA     VIA_dr_b                 ;97E3: B7 E2 00 
        LDA     M809C                    ;97E6: 96 9C 
        BRA     Z97EB                    ;97E8: 20 01 
;------------------------------------------------------------------------
Z97EA:	CLRA                             ;97EA: 4F 
Z97EB:	BRA     Z97F9                    ;97EB: 20 0C 
;------------------------------------------------------------------------
Z97ED:	ANDA    #$7F                     ;97ED: 84 7F 
        STA     M8094                    ;97EF: 97 94 
        LDA     M809C                    ;97F1: 96 9C 
        STA     VIA_dr_b                 ;97F3: B7 E2 00 
        ANDB    #$7F                     ;97F6: C4 7F 
        CLRA                             ;97F8: 4F 
Z97F9:	STB     M9847                    ;97F9: F7 98 47 
        LDX     M8094                    ;97FC: 9E 94 
        LDB     #$28                     ;97FE: C6 28 
        STB     $0B,Y                    ;9800: E7 2B 
        LDU     #DOC_adc                 ;9802: CE EC E2 
        CLR     M8099                    ;9805: 0F 99 
        LDY     #M0001                   ;9807: 10 8E 00 01 
Z980B:	LEAY    $01,Y                    ;980B: 31 21 
        BNE     Z9812                    ;980D: 26 03 
        LDA     #$01                     ;980F: 86 01 
        RTS                              ;9811: 39 
;------------------------------------------------------------------------
Z9812:	JSR     Z977B                    ;9812: BD 97 7B 
        TST     M8099                    ;9815: 0D 99 
        BEQ     Z980B                    ;9817: 27 F2 
        LDB     #$06                     ;9819: C6 06 
        STB     VIA_data                 ;981B: F7 E2 0F 
        LDY     #VIA_t1c_lsb             ;981E: 10 8E E2 04 
        SYNC                             ;9822: 13 
        LDB     ,Y                       ;9823: E6 A4 
        TSTA                             ;9825: 4D 
        BEQ     Z983C                    ;9826: 27 14 
Z9828:	SYNC                             ;9828: 13 
        LDB     ,Y                       ;9829: E6 A4 
        LDB     ,U                       ;982B: E6 C4 
        BNE     Z9830                    ;982D: 26 01 
        INCB                             ;982F: 5C 
Z9830:	STB     ,X+                      ;9830: E7 80 
        CMPX    #M8000                   ;9832: 8C 80 00 
        BCS     Z9828                    ;9835: 25 F1 
        STA     -$04,Y                   ;9837: A7 3C 
        LDX     #M0000                   ;9839: 8E 00 00 
Z983C:	SYNC                             ;983C: 13 
        LDB     ,Y                       ;983D: E6 A4 
        LDB     ,U                       ;983F: E6 C4 
        BNE     Z9844                    ;9841: 26 01 
        INCB                             ;9843: 5C 
Z9844:	STB     ,X+                      ;9844: E7 80 
        CMPX    #M00F0                   ;9846: 8C 00 F0 
        BCS     Z983C                    ;9849: 25 F1 
        LDD     #M1000                   ;984B: CC 10 00 
Z984E:	STB     ,X+                      ;984E: E7 80 
        DECA                             ;9850: 4A 
        BNE     Z984E                    ;9851: 26 FB 
        JSR     Z9941                    ;9853: BD 99 41 
        CLRA                             ;9856: 4F 
        RTS                              ;9857: 39 
;------------------------------------------------------------------------
Z9858:	LDA     VIA_dr_b                 ;9858: B6 E2 00 
        ANDA    #$FC                     ;985B: 84 FC 
        LDB     M80A4                    ;985D: D6 A4 
        BEQ     Z9863                    ;985F: 27 02 
        ORA     #$02                     ;9861: 8A 02 
Z9863:	STA     M809B                    ;9863: 97 9B 
        INCA                             ;9865: 4C 
        STA     M809C                    ;9866: 97 9C 
        STA     VIA_dr_b                 ;9868: B7 E2 00 
        RTS                              ;986B: 39 
;------------------------------------------------------------------------
Z986C:	JSR     Z9A85                    ;986C: BD 9A 85 
        LDD     $0F,X                    ;986F: EC 0F 
        STB     M8096                    ;9871: D7 96 
        STA     M8094                    ;9873: 97 94 
        RTS                              ;9875: 39 
;------------------------------------------------------------------------
Z9876:	TFR     U,X                      ;9876: 1F 31 
        CMPX    #M8000                   ;9878: 8C 80 00 
        BCC     Z9881                    ;987B: 24 04 
        LDA     M809B                    ;987D: 96 9B 
        BRA     Z9887                    ;987F: 20 06 
;------------------------------------------------------------------------
Z9881:	LEAX    $8000,X                  ;9881: 30 89 80 00 
        LDA     M809C                    ;9885: 96 9C 
Z9887:	STA     VIA_dr_b                 ;9887: B7 E2 00 
        LEAU    $01,U                    ;988A: 33 41 
        LDB     ,X                       ;988C: E6 84 
        RTS                              ;988E: 39 
;------------------------------------------------------------------------
Z988F:	TFR     Y,X                      ;988F: 1F 21 
        LDA     VIA_dr_b                 ;9891: B6 E2 00 
        CMPX    #M8000                   ;9894: 8C 80 00 
        BCC     Z989D                    ;9897: 24 04 
        LDA     M809B                    ;9899: 96 9B 
        BRA     Z98A3                    ;989B: 20 06 
;------------------------------------------------------------------------
Z989D:	LDA     M809C                    ;989D: 96 9C 
        LEAX    $8000,X                  ;989F: 30 89 80 00 
Z98A3:	STA     VIA_dr_b                 ;98A3: B7 E2 00 
        LEAY    $01,Y                    ;98A6: 31 21 
        STB     ,X                       ;98A8: E7 84 
        RTS                              ;98AA: 39 
;------------------------------------------------------------------------
Z98AB:	BSR     Z98EB                    ;98AB: 8D 3E 
        JSR     Z986C                    ;98AD: BD 98 6C 
        LDU     M8096                    ;98B0: DE 96 
        LEAU    -$01,U                   ;98B2: 33 5F 
        TFR     U,Y                      ;98B4: 1F 32 
        BSR     Z9876                    ;98B6: 8D BE 
        PSHS    B                        ;98B8: 34 04 
Z98BA:	LEAU    -$02,U                   ;98BA: 33 5E 
        BSR     Z9876                    ;98BC: 8D B8 
        BSR     Z988F                    ;98BE: 8D CF 
        LEAY    -$02,Y                   ;98C0: 31 3E 
        CMPY    M8094                    ;98C2: 10 9C 94 
        BNE     Z98BA                    ;98C5: 26 F3 
        PULS    B                        ;98C7: 35 04 
        BSR     Z988F                    ;98C9: 8D C4 
        BSR     Z9941                    ;98CB: 8D 74 
        RTS                              ;98CD: 39 
;------------------------------------------------------------------------
Z98CE:	BSR     Z98EB                    ;98CE: 8D 1B 
        JSR     Z986C                    ;98D0: BD 98 6C 
        LDU     M8094                    ;98D3: DE 94 
        TFR     U,Y                      ;98D5: 1F 32 
        BSR     Z9876                    ;98D7: 8D 9D 
        PSHS    B                        ;98D9: 34 04 
Z98DB:	BSR     Z9876                    ;98DB: 8D 99 
        BSR     Z988F                    ;98DD: 8D B0 
        CMPU    M8096                    ;98DF: 11 93 96 
        BNE     Z98DB                    ;98E2: 26 F7 
        PULS    B                        ;98E4: 35 04 
        BSR     Z988F                    ;98E6: 8D A7 
        BSR     Z9941                    ;98E8: 8D 57 
        RTS                              ;98EA: 39 
;------------------------------------------------------------------------
Z98EB:	JSR     Z9858                    ;98EB: BD 98 58 
        JSR     Z986C                    ;98EE: BD 98 6C 
        TST     $08,Y                    ;98F1: 6D 28 
        BEQ     Z9940                    ;98F3: 27 4B 
        LDA     $11,Y                    ;98F5: A6 A8 11 
        CMPA    $0F,Y                    ;98F8: A1 2F 
        BEQ     Z9921                    ;98FA: 27 25 
        CLRB                             ;98FC: 5F 
        TFR     D,U                      ;98FD: 1F 03 
        LEAU    -$01,U                   ;98FF: 33 5F 
        JSR     Z9876                    ;9901: BD 98 76 
        BNE     Z9921                    ;9904: 26 1B 
        LEAY    -$01,U                   ;9906: 31 5F 
        LEAU    -$09,U                   ;9908: 33 57 
        LDX     M8094                    ;990A: 9E 94 
        LEAX    $08,X                    ;990C: 30 08 
        PSHS    X                        ;990E: 34 10 
Z9910:	JSR     Z9876                    ;9910: BD 98 76 
        JSR     Z988F                    ;9913: BD 98 8F 
        LEAU    -$02,U                   ;9916: 33 5E 
        LEAY    -$02,Y                   ;9918: 31 3E 
        CMPY    ,S                       ;991A: 10 AC E4 
        BCC     Z9910                    ;991D: 24 F1 
        LEAS    $02,S                    ;991F: 32 62 
Z9921:	JSR     Z9A85                    ;9921: BD 9A 85 
        LDU     M8096                    ;9924: DE 96 
        LDY     $12,Y                    ;9926: 10 AE A8 12 
        LEAY    $01,Y                    ;992A: 31 21 
        LEAX    $10,U                    ;992C: 30 C8 10 
        PSHS    X                        ;992F: 34 10 
Z9931:	JSR     Z9876                    ;9931: BD 98 76 
        CLR     ,X                       ;9934: 6F 84 
        JSR     Z988F                    ;9936: BD 98 8F 
        CMPU    ,S                       ;9939: 11 A3 E4 
        BNE     Z9931                    ;993C: 26 F3 
        LEAS    $02,S                    ;993E: 32 62 
Z9940:	RTS                              ;9940: 39 
;------------------------------------------------------------------------
Z9941:	JSR     Z9A85                    ;9941: BD 9A 85 
        LDA     $08,Y                    ;9944: A6 28 
        BEQ     Z998A                    ;9946: 27 42 
        JSR     Z9858                    ;9948: BD 98 58 
        JSR     Z986C                    ;994B: BD 98 6C 
        LDU     $06,Y                    ;994E: EE 26 
        LDD     $12,Y                    ;9950: EC A8 12 
        CMPA    -$02,U                   ;9953: A1 5E 
        BNE     Z995D                    ;9955: 26 06 
        CMPB    #$80                     ;9957: C1 80 
        BCC     Z995D                    ;9959: 24 02 
        LDB     #$FF                     ;995B: C6 FF 
Z995D:	CMPA    $10,Y                    ;995D: A1 A8 10 
        BNE     Z996B                    ;9960: 26 09 
        CMPB    #$DF                     ;9962: C1 DF 
        BLS     Z996B                    ;9964: 23 05 
        LDB     #$DF                     ;9966: C6 DF 
        CLR     $14,Y                    ;9968: 6F A8 14 
Z996B:	STB     $13,Y                    ;996B: E7 A8 13 
        LDU     $12,Y                    ;996E: EE A8 12 
        LEAU    $01,U                    ;9971: 33 41 
        LDY     M8096                    ;9973: 10 9E 96 
        LEAX    $10,Y                    ;9976: 30 A8 10 
        PSHS    X                        ;9979: 34 10 
Z997B:	JSR     Z9876                    ;997B: BD 98 76 
        CLR     ,X                       ;997E: 6F 84 
        JSR     Z988F                    ;9980: BD 98 8F 
        CMPY    ,S                       ;9983: 10 AC E4 
        BNE     Z997B                    ;9986: 26 F3 
        LEAS    $02,S                    ;9988: 32 62 
Z998A:	RTS                              ;998A: 39 
;------------------------------------------------------------------------
Z998B:	LDU     #data_9ff3_via_U         ;998B: CE 9F F3 
        LDB     M808B                    ;998E: D6 8B 
        LDA     B,U                      ;9990: A6 C5 
        STA     M80AC                    ;9992: 97 AC 
        TFR     A,B                      ;9994: 1F 89 
        ANDB    #$3F                     ;9996: C4 3F 
        ANDA    #$80                     ;9998: 84 80 
        STA     M80AB                    ;999A: 97 AB 
        CLR     M80A1                    ;999C: 0F A1 
        CLR     M80A3                    ;999E: 0F A3 
        LDA     #$01                     ;99A0: 86 01 
        STA     M80A2                    ;99A2: 97 A2 
        LDA     M808B                    ;99A4: 96 8B 
        CMPA    #$1E                     ;99A6: 81 1E 
        BNE     Z99B0                    ;99A8: 26 06 
        LDX     #word_801c_X             ;99AA: 8E 80 1C 
        JMP     Z9CC1                    ;99AD: 7E 9C C1 
;------------------------------------------------------------------------
Z99B0:	LDA     M808B                    ;99B0: 96 8B 
        CMPA    #$1B                     ;99B2: 81 1B 
        LBCS    Z9A73                    ;99B4: 10 25 00 BB 
        CMPA    #$3B                     ;99B8: 81 3B 
        LBHI    Z9A73                    ;99BA: 10 22 00 B5 
        BSR     Z99C2                    ;99BE: 8D 02 
        BRA     Z99CE                    ;99C0: 20 0C 
;------------------------------------------------------------------------
Z99C2:	TST     M80A4                    ;99C2: 0D A4 
        BEQ     Z99CA                    ;99C4: 27 04 
        LDY     vec_80a5                 ;99C6: 10 9E A5 
        RTS                              ;99C9: 39 
;------------------------------------------------------------------------
Z99CA:	LDY     vec_80a7                 ;99CA: 10 9E A7 
        RTS                              ;99CD: 39 
;------------------------------------------------------------------------
Z99CE:	LDA     M808B                    ;99CE: 96 8B 
        CMPA    #$1B                     ;99D0: 81 1B 
        LBNE    Z99EE                    ;99D2: 10 26 00 18 
        LEAX    $0A,Y                    ;99D6: 30 2A 
        LDA     #$07                     ;99D8: 86 07 
        STA     M80A0                    ;99DA: 97 A0 
        INC     M80A3                    ;99DC: 0C A3 
        TST     M8084                    ;99DE: 0D 84 
        LBEQ    Z9CC1                    ;99E0: 10 27 02 DD 
        JSR     Z9CC1                    ;99E4: BD 9C C1 
        JSR     Z8ECF                    ;99E7: BD 8E CF 
        RTS                              ;99EA: 39 
;------------------------------------------------------------------------
        LBRA    Z9A4D                    ;99EB: 16 00 5F 
Z99EE:	CMPA    #$1C                     ;99EE: 81 1C 
        LBNE    Z9A06                    ;99F0: 10 26 00 12 
        LEAX    $0B,Y                    ;99F4: 30 2B 
        TST     M8084                    ;99F6: 0D 84 
        LBEQ    Z9CC5                    ;99F8: 10 27 02 C9 
        JSR     Z9CC1                    ;99FC: BD 9C C1 
        JSR     Z8ECF                    ;99FF: BD 8E CF 
        RTS                              ;9A02: 39 
;------------------------------------------------------------------------
        LBRA    Z9A4D                    ;9A03: 16 00 47 
Z9A06:	CMPA    #$1D                     ;9A06: 81 1D 
        LBNE    Z9A20                    ;9A08: 10 26 00 14 
        TST     M8084                    ;9A0C: 0D 84 
        LBEQ    Z9A67                    ;9A0E: 10 27 00 55 
        PSHS    Y,D                      ;9A12: 34 26 
        ORCC    #$50                     ;9A14: 1A 50 
        JSR     task_handler_875e        ;9A16: BD 87 5E 
        ANDCC   #$AF                     ;9A19: 1C AF 
        PULS    Y,D                      ;9A1B: 35 26 
        LBRA    Z9A4D                    ;9A1D: 16 00 2D 
Z9A20:	CMPA    #$22                     ;9A20: 81 22 
        LBNE    Z9A2C                    ;9A22: 10 26 00 06 
        JSR     Z9D41                    ;9A26: BD 9D 41 
        LBRA    Z9A4D                    ;9A29: 16 00 21 
Z9A2C:	CMPA    #$23                     ;9A2C: 81 23 
        LBNE    Z9A38                    ;9A2E: 10 26 00 06 
        JSR     Z9D41                    ;9A32: BD 9D 41 
        LBRA    Z9A4D                    ;9A35: 16 00 15 
Z9A38:	CMPA    #$24                     ;9A38: 81 24 
        LBNE    Z9A44                    ;9A3A: 10 26 00 06 
        JSR     Z9D38                    ;9A3E: BD 9D 38 
        LBRA    Z9A4D                    ;9A41: 16 00 09 
Z9A44:	CMPA    #$25                     ;9A44: 81 25 
        LBNE    Z9A4D                    ;9A46: 10 26 00 03 
        JSR     Z9D41                    ;9A4A: BD 9D 41 
Z9A4D:	LDA     M808B                    ;9A4D: 96 8B 
        CMPA    #$2D                     ;9A4F: 81 2D 
        BCS     Z9A5A                    ;9A51: 25 07 
        CMPA    #$31                     ;9A53: 81 31 
        BHI     Z9A5A                    ;9A55: 22 03 
        JSR     Z9D41                    ;9A57: BD 9D 41 
Z9A5A:	LDA     M808B                    ;9A5A: 96 8B 
        CMPA    #$37                     ;9A5C: 81 37 
        BCS     Z9A67                    ;9A5E: 25 07 
        CMPA    #$3B                     ;9A60: 81 3B 
        BHI     Z9A67                    ;9A62: 22 03 
        JSR     Z9D41                    ;9A64: BD 9D 41 
Z9A67:	LDX     #data_a057_via_X         ;9A67: 8E A0 57 
        LDA     B,X                      ;9A6A: A6 85 
        STA     M80A0                    ;9A6C: 97 A0 
        LEAX    B,Y                      ;9A6E: 30 A5 
        JMP     Z9CC1                    ;9A70: 7E 9C C1 
;------------------------------------------------------------------------
Z9A73:	LDA     M808B                    ;9A73: 96 8B 
        CMPA    #$3C                     ;9A75: 81 3C 
        LBCS    Z9B2F                    ;9A77: 10 25 00 B4 
        CMPA    #$48                     ;9A7B: 81 48 
        LBHI    Z9B2F                    ;9A7D: 10 22 00 AE 
        BSR     Z9A85                    ;9A81: 8D 02 
        BRA     Z9AA1                    ;9A83: 20 1C 
;------------------------------------------------------------------------
Z9A85:	LDA     M80A4                    ;9A85: 96 A4 
        BEQ     Z9A93                    ;9A87: 27 0A 
        LDY     #vectors_8ebf            ;9A89: 10 8E 8E BF 
        LDU     vec_80a5                 ;9A8D: DE A5 
        LDA     vector_80a9_X            ;9A8F: 96 A9 
        BRA     Z9A9B                    ;9A91: 20 08 
;------------------------------------------------------------------------
Z9A93:	LDY     #vectors_8eaf            ;9A93: 10 8E 8E AF 
        LDU     vec_80a7                 ;9A97: DE A7 
        LDA     vector_80aa_X            ;9A99: 96 AA 
Z9A9B:	ASLA                             ;9A9B: 48 
        LDX     A,Y                      ;9A9C: AE A6 
        TFR     X,Y                      ;9A9E: 1F 12 
        RTS                              ;9AA0: 39 
;------------------------------------------------------------------------
Z9AA1:	LEAX    B,X                      ;9AA1: 30 85 
        STX     M809D                    ;9AA3: 9F 9D 
        LDA     M808B                    ;9AA5: 96 8B 
        CMPA    #$3C                     ;9AA7: 81 3C 
        BCS     Z9AC7                    ;9AA9: 25 1C 
        CMPA    #$40                     ;9AAB: 81 40 
        BHI     Z9AC7                    ;9AAD: 22 18 
        TST     M8084                    ;9AAF: 0D 84 
        BEQ     Z9AC0                    ;9AB1: 27 0D 
        BMI     Z9ABA                    ;9AB3: 2B 05 
        LDA     ,X                       ;9AB5: A6 84 
        INCA                             ;9AB7: 4C 
        BRA     Z9ABD                    ;9AB8: 20 03 
;------------------------------------------------------------------------
Z9ABA:	LDA     ,X                       ;9ABA: A6 84 
        DECA                             ;9ABC: 4A 
Z9ABD:	JSR     Z8F11                    ;9ABD: BD 8F 11 
Z9AC0:	LDX     M809D                    ;9AC0: 9E 9D 
        LDB     ,X                       ;9AC2: E6 84 
        JMP     Z9D15                    ;9AC4: 7E 9D 15 
;------------------------------------------------------------------------
Z9AC7:	LDA     M808B                    ;9AC7: 96 8B 
        CMPA    #$41                     ;9AC9: 81 41 
        BNE     Z9AE2                    ;9ACB: 26 15 
        TST     M8084                    ;9ACD: 0D 84 
        BEQ     Z9ADD                    ;9ACF: 27 0C 
        BMI     Z9AD7                    ;9AD1: 2B 04 
        LDA     #$01                     ;9AD3: 86 01 
        BRA     Z9AD8                    ;9AD5: 20 01 
;------------------------------------------------------------------------
Z9AD7:	CLRA                             ;9AD7: 4F 
Z9AD8:	LDB     #$08                     ;9AD8: C6 08 
        JSR     Z8F11                    ;9ADA: BD 8F 11 
Z9ADD:	LDX     M809D                    ;9ADD: 9E 9D 
        JMP     Z9CD3                    ;9ADF: 7E 9C D3 
;------------------------------------------------------------------------
Z9AE2:	LDA     M808B                    ;9AE2: 96 8B 
        CMPA    #$42                     ;9AE4: 81 42 
        BNE     Z9B02                    ;9AE6: 26 1A 
        LDX     #809f_via_X              ;9AE8: 8E 80 9F 
        TST     M8084                    ;9AEB: 0D 84 
        BEQ     Z9AFD                    ;9AED: 27 0E 
        BMI     Z9AF8                    ;9AEF: 2B 07 
        INC     ,X                       ;9AF1: 6C 84 
        JSR     Z98AB                    ;9AF3: BD 98 AB 
        BRA     Z9AFD                    ;9AF6: 20 05 
;------------------------------------------------------------------------
Z9AF8:	DEC     ,X                       ;9AF8: 6A 84 
        JSR     Z98CE                    ;9AFA: BD 98 CE 
Z9AFD:	LDB     ,X                       ;9AFD: E6 84 
        LBRA    Z9D15                    ;9AFF: 16 02 13 
Z9B02:	LDA     M808B                    ;9B02: 96 8B 
        CMPA    #$46                     ;9B04: 81 46 
        BEQ     Z9B0C                    ;9B06: 27 04 
        CMPA    #$47                     ;9B08: 81 47 
        BNE     Z9B0F                    ;9B0A: 26 03 
Z9B0C:	JSR     Z9D38                    ;9B0C: BD 9D 38 
Z9B0F:	LDA     M808B                    ;9B0F: 96 8B 
        CMPA    #$48                     ;9B11: 81 48 
        BNE     Z9B23                    ;9B13: 26 0E 
        LDA     #$01                     ;9B15: 86 01 
        STA     M80A3                    ;9B17: 97 A3 
        TST     M8084                    ;9B19: 0D 84 
        BEQ     Z9B23                    ;9B1B: 27 06 
        BSR     Z9B23                    ;9B1D: 8D 04 
        JSR     Z8ECF                    ;9B1F: BD 8E CF 
        RTS                              ;9B22: 39 
;------------------------------------------------------------------------
Z9B23:	LDU     #data_a077_via_U         ;9B23: CE A0 77 
        SUBB    #$08                     ;9B26: C0 08 
        LDA     B,U                      ;9B28: A6 C5 
        STA     M80A0                    ;9B2A: 97 A0 
        JMP     Z9CC1                    ;9B2C: 7E 9C C1 
;------------------------------------------------------------------------
Z9B2F:	LDA     M808B                    ;9B2F: 96 8B 
        CMPA    #$51                     ;9B31: 81 51 
        BCS     Z9B95                    ;9B33: 25 60 
        CMPA    #$58                     ;9B35: 81 58 
        BHI     Z9B95                    ;9B37: 22 5C 
        CMPA    #$51                     ;9B39: 81 51 
        BNE     Z9B42                    ;9B3B: 26 05 
        LDX     #word_8020_X             ;9B3D: 8E 80 20 
        BRA     Z9B92                    ;9B40: 20 50 
;------------------------------------------------------------------------
Z9B42:	CMPA    #$52                     ;9B42: 81 52 
        BNE     Z9B51                    ;9B44: 26 0B 
        LDA     #$01                     ;9B46: 86 01 
        STA     M80A3                    ;9B48: 97 A3 
        STB     M80A0                    ;9B4A: D7 A0 
        LDX     #MIDI_channel            ;9B4C: 8E 80 21 
        BRA     Z9B92                    ;9B4F: 20 41 
;------------------------------------------------------------------------
Z9B51:	CMPA    #$53                     ;9B51: 81 53 
        BNE     Z9B5A                    ;9B53: 26 05 
        LDX     #MIDI_thru_enabled       ;9B55: 8E 80 22 
        BRA     Z9B92                    ;9B58: 20 38 
;------------------------------------------------------------------------
Z9B5A:	CMPA    #$54                     ;9B5A: 81 54 
        BNE     Z9B65                    ;9B5C: 26 07 
        LDX     #word_8023_X             ;9B5E: 8E 80 23 
        STB     M80A0                    ;9B61: D7 A0 
        BRA     Z9B92                    ;9B63: 20 2D 
;------------------------------------------------------------------------
Z9B65:	CMPA    #$55                     ;9B65: 81 55 
        BNE     Z9B6E                    ;9B67: 26 05 
        LDX     #word_8024_X             ;9B69: 8E 80 24 
        BRA     Z9B92                    ;9B6C: 20 24 
;------------------------------------------------------------------------
Z9B6E:	CMPA    #$56                     ;9B6E: 81 56 
        BNE     Z9B77                    ;9B70: 26 05 
        LDX     #word_8025_X             ;9B72: 8E 80 25 
        BRA     Z9B92                    ;9B75: 20 1B 
;------------------------------------------------------------------------
Z9B77:	CMPA    #$57                     ;9B77: 81 57 
        BNE     Z9B8B                    ;9B79: 26 10 
        JSR     Z9D38                    ;9B7B: BD 9D 38 
        LDA     #$C6                     ;9B7E: 86 C6 
        STA     M80A0                    ;9B80: 97 A0 
        LDA     #$01                     ;9B82: 86 01 
        STA     M80A1                    ;9B84: 97 A1 
        LDX     #word_8026_X             ;9B86: 8E 80 26 
        BRA     Z9B92                    ;9B89: 20 07 
;------------------------------------------------------------------------
Z9B8B:	CMPA    #$58                     ;9B8B: 81 58 
        BNE     Z9B92                    ;9B8D: 26 03 
        LDX     #word_8027_X             ;9B8F: 8E 80 27 
Z9B92:	JMP     Z9CC1                    ;9B92: 7E 9C C1 
;------------------------------------------------------------------------
Z9B95:	LDA     M808B                    ;9B95: 96 8B 
        CMPA    #$18                     ;9B97: 81 18 
        BNE     Z9BA8                    ;9B99: 26 0D 
        LDX     #osparm_upperlower       ;9B9B: 8E 80 15 
        JSR     Z9D38                    ;9B9E: BD 9D 38 
        LDA     #$7E                     ;9BA1: 86 7E 
        STA     M80A0                    ;9BA3: 97 A0 
        JMP     Z9CC1                    ;9BA5: 7E 9C C1 
;------------------------------------------------------------------------
Z9BA8:	CMPA    #$19                     ;9BA8: 81 19 
        BNE     Z9BB2                    ;9BAA: 26 06 
        LDX     #word_8016_X             ;9BAC: 8E 80 16 
        JMP     Z9CC1                    ;9BAF: 7E 9C C1 
;------------------------------------------------------------------------
Z9BB2:	CMPA    #$1A                     ;9BB2: 81 1A 
        BNE     Z9BCA                    ;9BB4: 26 14 
        CLR     809f_via_X               ;9BB6: 0F 9F 
        TST     M80A4                    ;9BB8: 0D A4 
        BEQ     Z9BC1                    ;9BBA: 27 05 
        LDX     #vector_80a9_X           ;9BBC: 8E 80 A9 
        BRA     Z9BC4                    ;9BBF: 20 03 
;------------------------------------------------------------------------
Z9BC1:	LDX     #vector_80aa_X           ;9BC1: 8E 80 AA 
Z9BC4:	LDA     #$01                     ;9BC4: 86 01 
        STA     M80A3                    ;9BC6: 97 A3 
        BRA     Z9BE8                    ;9BC8: 20 1E 
;------------------------------------------------------------------------
Z9BCA:	CMPA    #$15                     ;9BCA: 81 15 
        BNE     Z9BD8                    ;9BCC: 26 0A 
        LDA     #$63                     ;9BCE: 86 63 
        STA     M80A0                    ;9BD0: 97 A0 
        LDX     #osparm_tuning           ;9BD2: 8E 80 12 
        LBRA    Z9CC1                    ;9BD5: 16 00 E9 
Z9BD8:	CMPA    #$16                     ;9BD8: 81 16 
        BNE     Z9BE1                    ;9BDA: 26 05 
        LDX     #osparm_bendrange        ;9BDC: 8E 80 13 
        BRA     Z9BE8                    ;9BDF: 20 07 
;------------------------------------------------------------------------
Z9BE1:	CMPA    #$17                     ;9BE1: 81 17 
        BNE     Z9BED                    ;9BE3: 26 08 
        LDX     #osparm_velosens         ;9BE5: 8E 80 14 
Z9BE8:	STB     M80A0                    ;9BE8: D7 A0 
        JMP     Z9CC1                    ;9BEA: 7E 9C C1 
;------------------------------------------------------------------------
Z9BED:	CMPA    #$49                     ;9BED: 81 49 
        BNE     Z9BFF                    ;9BEF: 26 0E 
        LDA     #$1E                     ;9BF1: 86 1E 
        STA     M80A1                    ;9BF3: 97 A1 
        LDA     #$63                     ;9BF5: 86 63 
        STA     M80A0                    ;9BF7: 97 A0 
        LDX     #word_8017_X             ;9BF9: 8E 80 17 
        LBRA    Z9CC1                    ;9BFC: 16 00 C2 
Z9BFF:	CMPA    #$4A                     ;9BFF: 81 4A 
        BNE     Z9C10                    ;9C01: 26 0D 
        JSR     Z9D38                    ;9C03: BD 9D 38 
        LDA     #$C6                     ;9C06: 86 C6 
        STA     M80A0                    ;9C08: 97 A0 
        LDX     #word_8018_X             ;9C0A: 8E 80 18 
        LBRA    Z9CC1                    ;9C0D: 16 00 B1 
Z9C10:	CMPA    #$4B                     ;9C10: 81 4B 
        BNE     Z9C1A                    ;9C12: 26 06 
        LDX     #word_8019_X             ;9C14: 8E 80 19 
        LBRA    Z9CC1                    ;9C17: 16 00 A7 
Z9C1A:	CMPA    #$4C                     ;9C1A: 81 4C 
        BNE     Z9C2B                    ;9C1C: 26 0D 
        JSR     Z9D38                    ;9C1E: BD 9D 38 
        LDX     #word_801a_X             ;9C21: 8E 80 1A 
        LDA     #$7E                     ;9C24: 86 7E 
        STA     M80A0                    ;9C26: 97 A0 
        LBRA    Z9CC1                    ;9C28: 16 00 96 
Z9C2B:	CMPA    #$4D                     ;9C2B: 81 4D 
        BNE     Z9C35                    ;9C2D: 26 06 
        LDX     #word_801b_X             ;9C2F: 8E 80 1B 
        LBRA    Z9CC1                    ;9C32: 16 00 8C 
Z9C35:	CMPA    #$4E                     ;9C35: 81 4E 
        BNE     Z9C3E                    ;9C37: 26 05 
        LDX     #word_801d_X             ;9C39: 8E 80 1D 
        BRA     Z9BE8                    ;9C3C: 20 AA 
;------------------------------------------------------------------------
Z9C3E:	CMPA    #$4F                     ;9C3E: 81 4F 
        BNE     Z9C48                    ;9C40: 26 06 
        LDX     #word_801e_X             ;9C42: 8E 80 1E 
        LBRA    Z9BE8                    ;9C45: 16 FF A0 
Z9C48:	CMPA    #$50                     ;9C48: 81 50 
        BNE     Z9C58                    ;9C4A: 26 0C 
        JSR     Z9D38                    ;9C4C: BD 9D 38 
        LDX     #word_801f_X             ;9C4F: 8E 80 1F 
        LDA     #$7E                     ;9C52: 86 7E 
        STA     M80A0                    ;9C54: 97 A0 
        BRA     Z9CC1                    ;9C56: 20 69 
;------------------------------------------------------------------------
Z9C58:	CMPA    #$59                     ;9C58: 81 59 
        BNE     Z9C76                    ;9C5A: 26 1A 
        TST     M8084                    ;9C5C: 0D 84 
        BEQ     Z9C70                    ;9C5E: 27 10 
        BMI     Z9C6E                    ;9C60: 2B 0C 
        LDA     #$01                     ;9C62: 86 01 
        STA     word_8028_X              ;9C64: 97 28 
        CLR     kbd_flag_damper_pedal_onoff ;9C66: 0F 6B 
        JSR     Z87DD                    ;9C68: BD 87 DD 
        JMP     Z9C70                    ;9C6B: 7E 9C 70 
;------------------------------------------------------------------------
Z9C6E:	CLR     word_8028_X              ;9C6E: 0F 28 
Z9C70:	LDX     #word_8028_X             ;9C70: 8E 80 28 
        JMP     Z9CD3                    ;9C73: 7E 9C D3 
;------------------------------------------------------------------------
Z9C76:	CMPA    #$5B                     ;9C76: 81 5B 
        BNE     Z9C7F                    ;9C78: 26 05 
        LDX     #word_8029_X             ;9C7A: 8E 80 29 
        BRA     Z9CC1                    ;9C7D: 20 42 
;------------------------------------------------------------------------
Z9C7F:	CMPA    #$5C                     ;9C7F: 81 5C 
        BNE     Z9C98                    ;9C81: 26 15 
        LDX     #word_802a_X             ;9C83: 8E 80 2A 
        TST     M8084                    ;9C86: 0D 84 
        BEQ     Z9C96                    ;9C88: 27 0C 
        BMI     Z9C93                    ;9C8A: 2B 07 
        LDA     #$0B                     ;9C8C: 86 0B 
        STA     VIA_t1_lsb               ;9C8E: B7 E2 06 
        BRA     Z9C96                    ;9C91: 20 03 
;------------------------------------------------------------------------
Z9C93:	CLR     VIA_t1_lsb               ;9C93: 7F E2 06 
Z9C96:	BRA     Z9CC1                    ;9C96: 20 29 
;------------------------------------------------------------------------
Z9C98:	CMPA    #$61                     ;9C98: 81 61 
        BNE     Z9CA3                    ;9C9A: 26 07 
        CLR     M8084                    ;9C9C: 0F 84 
        LDX     #word_802b_X             ;9C9E: 8E 80 2B 
        BRA     Z9CC1                    ;9CA1: 20 1E 
;------------------------------------------------------------------------
Z9CA3:	CMPA    #$62                     ;9CA3: 81 62 
        BNE     Z9CAE                    ;9CA5: 26 07 
        CLR     M8084                    ;9CA7: 0F 84 
        LDX     #word_8007_X             ;9CA9: 8E 80 07 
        BRA     Z9CC1                    ;9CAC: 20 13 
;------------------------------------------------------------------------
Z9CAE:	CMPA    #$63                     ;9CAE: 81 63 
        BNE     Z9CB9                    ;9CB0: 26 07 
        CLR     M8084                    ;9CB2: 0F 84 
        LDX     #word_8006_X             ;9CB4: 8E 80 06 
        BRA     Z9CC1                    ;9CB7: 20 08 
;------------------------------------------------------------------------
Z9CB9:	JSR     Z9431                    ;9CB9: BD 94 31 
        LDD     #M1112                   ;9CBC: CC 11 12 
        BRA     Z9D23                    ;9CBF: 20 62 
;------------------------------------------------------------------------
Z9CC1:	TST     M80AB                    ;9CC1: 0D AB 
        BEQ     Z9CDF                    ;9CC3: 27 1A 
Z9CC5:	TST     M8084                    ;9CC5: 0D 84 
        BEQ     Z9CD3                    ;9CC7: 27 0A 
        BMI     Z9CD1                    ;9CC9: 2B 06 
        LDA     #$01                     ;9CCB: 86 01 
        STA     ,X                       ;9CCD: A7 84 
        BRA     Z9CD3                    ;9CCF: 20 02 
;------------------------------------------------------------------------
Z9CD1:	CLR     ,X                       ;9CD1: 6F 84 
Z9CD3:	LDD     #M1211                   ;9CD3: CC 12 11 
        TST     ,X                       ;9CD6: 6D 84 
        BNE     Z9CDC                    ;9CD8: 26 02 
        LDB     #$0F                     ;9CDA: C6 0F 
Z9CDC:	JMP     Z9D23                    ;9CDC: 7E 9D 23 
;------------------------------------------------------------------------
Z9CDF:	TST     M8084                    ;9CDF: 0D 84 
        BEQ     Z9CFB                    ;9CE1: 27 18 
        BMI     Z9CF1                    ;9CE3: 2B 0C 
        LDB     ,X                       ;9CE5: E6 84 
        CMPB    M80A0                    ;9CE7: D1 A0 
        BCC     Z9CFB                    ;9CE9: 24 10 
        ADDB    M80A2                    ;9CEB: DB A2 
        STB     ,X                       ;9CED: E7 84 
        BRA     Z9CFB                    ;9CEF: 20 0A 
;------------------------------------------------------------------------
Z9CF1:	LDB     ,X                       ;9CF1: E6 84 
        CMPB    M80A1                    ;9CF3: D1 A1 
        BLS     Z9CFB                    ;9CF5: 23 04 
        SUBB    M80A2                    ;9CF7: D0 A2 
        STB     ,X                       ;9CF9: E7 84 
Z9CFB:	LDB     ,X                       ;9CFB: E6 84 
        LDA     M80A3                    ;9CFD: 96 A3 
        BEQ     Z9D0F                    ;9CFF: 27 0E 
        BMI     Z9D06                    ;9D01: 2B 03 
        INCB                             ;9D03: 5C 
        BRA     Z9D0F                    ;9D04: 20 09 
;------------------------------------------------------------------------
Z9D06:	CMPA    #$81                     ;9D06: 81 81 
        BNE     Z9D0D                    ;9D08: 26 03 
        LSRB                             ;9D0A: 54 
        BRA     Z9D0F                    ;9D0B: 20 02 
;------------------------------------------------------------------------
Z9D0D:	LSRB                             ;9D0D: 54 
        LSRB                             ;9D0E: 54 
Z9D0F:	LDA     M80AC                    ;9D0F: 96 AC 
        ANDA    #$40                     ;9D11: 84 40 
        BEQ     Z9D21                    ;9D13: 27 0C 
Z9D15:	TFR     B,A                      ;9D15: 1F 98 
        LSRA                             ;9D17: 44 
        LSRA                             ;9D18: 44 
        LSRA                             ;9D19: 44 
        LSRA                             ;9D1A: 44 
        ANDA    #$0F                     ;9D1B: 84 0F 
        ANDB    #$0F                     ;9D1D: C4 0F 
        BRA     Z9D23                    ;9D1F: 20 02 
;------------------------------------------------------------------------
Z9D21:	BSR     Z9D2D                    ;9D21: 8D 0A 
Z9D23:	LDU     #ROM_LED_hexnum          ;9D23: CE FB 4D 
        LDA     A,U                      ;9D26: A6 C6 
        LDB     B,U                      ;9D28: E6 C5 
        STD     M80B3                    ;9D2A: DD B3 
        RTS                              ;9D2C: 39 
;------------------------------------------------------------------------
Z9D2D:	CLRA                             ;9D2D: 4F 
Z9D2E:	CMPB    #$0A                     ;9D2E: C1 0A 
        BCS     Z9D37                    ;9D30: 25 05 
        SUBB    #$0A                     ;9D32: C0 0A 
        INCA                             ;9D34: 4C 
        BRA     Z9D2E                    ;9D35: 20 F7 
;------------------------------------------------------------------------
Z9D37:	RTS                              ;9D37: 39 
;------------------------------------------------------------------------
Z9D38:	LDA     #$81                     ;9D38: 86 81 
        STA     M80A3                    ;9D3A: 97 A3 
        LDA     #$02                     ;9D3C: 86 02 
        STA     M80A2                    ;9D3E: 97 A2 
        RTS                              ;9D40: 39 
;------------------------------------------------------------------------
Z9D41:	LDA     #$82                     ;9D41: 86 82 
        STA     M80A3                    ;9D43: 97 A3 
        LDA     #$04                     ;9D45: 86 04 
        STA     M80A2                    ;9D47: 97 A2 
        RTS                              ;9D49: 39 
;------------------------------------------------------------------------
M9D4A:	FCB     $00                      ;9D4A: 00 
;------------------------------------------------------------------------
Z9D4B:	LDA     M9D4A                    ;9D4B: B6 9D 4A 
        CMPA    #$00                     ;9D4E: 81 00 
        BNE     Z9D88                    ;9D50: 26 36 
Z9D52:	JSR     Z9DD7                    ;9D52: BD 9D D7 
        LDA     M80AF                    ;9D55: 96 AF 
        CMPA    #$0B                     ;9D57: 81 0B 
        BEQ     Z9D5F                    ;9D59: 27 04 
        CMPA    #$11                     ;9D5B: 81 11 
        BNE     Z9D68                    ;9D5D: 26 09 
Z9D5F:	STA     M80AD                    ;9D5F: 97 AD 
        LDA     #$02                     ;9D61: 86 02 
        STA     M9D4A                    ;9D63: B7 9D 4A 
        BRA     Z9DB1                    ;9D66: 20 49 
;------------------------------------------------------------------------
Z9D68:	LDA     M80AF                    ;9D68: 96 AF 
        CMPA    #$F0                     ;9D6A: 81 F0 
        BEQ     Z9D84                    ;9D6C: 27 16 
        STA     M80AD                    ;9D6E: 97 AD 
        LDA     #$05                     ;9D70: 86 05 
        STA     M8031                    ;9D72: 97 31 
        LDA     #$01                     ;9D74: 86 01 
        STA     M9D4A                    ;9D76: B7 9D 4A 
        LDY     #ROM_keycode_xcode       ;9D79: 10 8E FB 68 
        LDB     M80AD                    ;9D7D: D6 AD 
        LDA     B,Y                      ;9D7F: A6 A5 
        STA     M80AE                    ;9D81: 97 AE 
        RTS                              ;9D83: 39 
;------------------------------------------------------------------------
Z9D84:	BRA     Z9D52                    ;9D84: 20 CC 
;------------------------------------------------------------------------
        BRA     Z9DD4                    ;9D86: 20 4C 
;------------------------------------------------------------------------
Z9D88:	CMPA    #$01                     ;9D88: 81 01 
        BNE     Z9DAD                    ;9D8A: 26 21 
Z9D8C:	JSR     Z9DD7                    ;9D8C: BD 9D D7 
        LDA     M8031                    ;9D8F: 96 31 
        BNE     Z9D8C                    ;9D91: 26 F9 
        LDA     M80AF                    ;9D93: 96 AF 
        CMPA    #$F0                     ;9D95: 81 F0 
        BNE     Z9D8C                    ;9D97: 26 F3 
        LDA     #$05                     ;9D99: 86 05 
        STA     M8031                    ;9D9B: 97 31 
Z9D9D:	JSR     Z9DD7                    ;9D9D: BD 9D D7 
        LDA     M8031                    ;9DA0: 96 31 
        BNE     Z9D9D                    ;9DA2: 26 F9 
        LDA     #$00                     ;9DA4: 86 00 
        STA     M9D4A                    ;9DA6: B7 9D 4A 
        BRA     Z9D52                    ;9DA9: 20 A7 
;------------------------------------------------------------------------
        BRA     Z9DD4                    ;9DAB: 20 27 
;------------------------------------------------------------------------
Z9DAD:	CMPA    #$02                     ;9DAD: 81 02 
        BNE     Z9DD4                    ;9DAF: 26 23 
Z9DB1:	JSR     Z9DD7                    ;9DB1: BD 9D D7 
        LDA     M80AF                    ;9DB4: 96 AF 
        CMPA    M80AD                    ;9DB6: 91 AD 
        BNE     Z9DC6                    ;9DB8: 26 0C 
        LDY     #ROM_keycode_xcode       ;9DBA: 10 8E FB 68 
        LDA     A,Y                      ;9DBE: A6 A6 
        STA     M80AE                    ;9DC0: 97 AE 
        BRA     Z9DD3                    ;9DC2: 20 0F 
;------------------------------------------------------------------------
        BRA     Z9DD3                    ;9DC4: 20 0D 
;------------------------------------------------------------------------
Z9DC6:	LDA     #$0D                     ;9DC6: 86 0D 
        STA     M80AE                    ;9DC8: 97 AE 
        LDA     #$05                     ;9DCA: 86 05 
        STA     M8031                    ;9DCC: 97 31 
        LDA     #$01                     ;9DCE: 86 01 
        STA     M9D4A                    ;9DD0: B7 9D 4A 
Z9DD3:	RTS                              ;9DD3: 39 
;------------------------------------------------------------------------
Z9DD4:	LBRA    Z9D52                    ;9DD4: 16 FF 7B 
Z9DD7:	LDD     M80B3                    ;9DD7: DC B3 
        TST     M8083                    ;9DD9: 0D 83 
        BMI     Z9DE3                    ;9DDB: 2B 06 
        BNE     Z9DE2                    ;9DDD: 26 03 
        INCA                             ;9DDF: 4C 
        BRA     Z9DE3                    ;9DE0: 20 01 
;------------------------------------------------------------------------
Z9DE2:	INCB                             ;9DE2: 5C 
Z9DE3:	STA     M80B5                    ;9DE3: 97 B5 
        STB     M80B6                    ;9DE5: D7 B6 
        CLRB                             ;9DE7: 5F 
        LDA     #$F0                     ;9DE8: 86 F0 
        STA     M80AF                    ;9DEA: 97 AF 
Z9DEC:	STB     M80B2                    ;9DEC: D7 B2 
        TFR     B,A                      ;9DEE: 1F 98 
        ORA     #$18                     ;9DF0: 8A 18 
        TST     M808A                    ;9DF2: 0D 8A 
        BEQ     Z9E00                    ;9DF4: 27 0A 
        LDB     #$80                     ;9DF6: C6 80 
        BITB    M8033                    ;9DF8: D5 33 
        BNE     Z9E00                    ;9DFA: 26 04 
        ASL     M80B5                    ;9DFC: 08 B5 
        BRA     Z9E06                    ;9DFE: 20 06 
;------------------------------------------------------------------------
Z9E00:	ASL     M80B5                    ;9E00: 08 B5 
        BCC     Z9E06                    ;9E02: 24 02 
        ANDA    #$F7                     ;9E04: 84 F7 
Z9E06:	TST     M8089                    ;9E06: 0D 89 
        BEQ     Z9E14                    ;9E08: 27 0A 
        LDB     #$80                     ;9E0A: C6 80 
        BITB    M8033                    ;9E0C: D5 33 
        BNE     Z9E14                    ;9E0E: 26 04 
        ASL     M80B6                    ;9E10: 08 B6 
        BRA     Z9E1A                    ;9E12: 20 06 
;------------------------------------------------------------------------
Z9E14:	ASL     M80B6                    ;9E14: 08 B6 
        BCC     Z9E1A                    ;9E16: 24 02 
        ANDA    #$EF                     ;9E18: 84 EF 
Z9E1A:	TFR     A,B                      ;9E1A: 1F 89 
        ORB     #$18                     ;9E1C: CA 18 
        STB     VIA_data                 ;9E1E: F7 E2 0F 
        EXG     X,Y                      ;9E21: 1E 12 
        EXG     X,Y                      ;9E23: 1E 12 
        LDB     VIA_data                 ;9E25: F6 E2 0F 
        ANDB    #$E0                     ;9E28: C4 E0 
        CMPB    #$E0                     ;9E2A: C1 E0 
        BNE     Z9E30                    ;9E2C: 26 02 
        LDB     #$0F                     ;9E2E: C6 0F 
Z9E30:	STB     M80B1                    ;9E30: D7 B1 
        STA     VIA_data                 ;9E32: B7 E2 0F 
        LDA     #$01                     ;9E35: 86 01 
        STA     M8037                    ;9E37: 97 37 
        JSR     context_switch           ;9E39: BD 88 5E 
        JSR     ZA41A                    ;9E3C: BD A4 1A 
        BCC     Z9E56                    ;9E3F: 24 15 
        STA     M80AE                    ;9E41: 97 AE 
        LDA     #$01                     ;9E43: 86 01 
        STA     M8208                    ;9E45: B7 82 08 
        JSR     Z90E9                    ;9E48: BD 90 E9 
        CLR     M8208                    ;9E4B: 7F 82 08 
        LDA     #$0F                     ;9E4E: 86 0F 
        STA     M80B1                    ;9E50: 97 B1 
        LDA     #$F0                     ;9E52: 86 F0 
        STA     M80AF                    ;9E54: 97 AF 
Z9E56:	TST     M8037                    ;9E56: 0D 37 
        BEQ     Z9E5F                    ;9E58: 27 05 
        JSR     context_switch           ;9E5A: BD 88 5E 
        BRA     Z9E56                    ;9E5D: 20 F7 
;------------------------------------------------------------------------
Z9E5F:	LDA     M80B1                    ;9E5F: 96 B1 
        CMPA    #$0F                     ;9E61: 81 0F 
        BEQ     Z9E79                    ;9E63: 27 14 
        LDA     #$02                     ;9E65: 86 02 
Z9E67:	ASL     M80B1                    ;9E67: 08 B1 
        BCC     Z9E6E                    ;9E69: 24 03 
        DECA                             ;9E6B: 4A 
        BRA     Z9E67                    ;9E6C: 20 F9 
;------------------------------------------------------------------------
Z9E6E:	STA     M80B0                    ;9E6E: 97 B0 
        LDB     M80B2                    ;9E70: D6 B2 
        ASLB                             ;9E72: 58 
        ADDB    M80B2                    ;9E73: DB B2 
        ADDB    M80B0                    ;9E75: DB B0 
        STB     M80AF                    ;9E77: D7 AF 
Z9E79:	LDB     M80B2                    ;9E79: D6 B2 
        INCB                             ;9E7B: 5C 
        CMPB    #$07                     ;9E7C: C1 07 
        LBLS    Z9DEC                    ;9E7E: 10 23 FF 6A 
        RTS                              ;9E82: 39 
;------------------------------------------------------------------------
Z9E83:	LDA     M8085                    ;9E83: 96 85 
        CMPA    #$01                     ;9E85: 81 01 
        BNE     Z9EA8                    ;9E87: 26 1F 
        LDA     M8223                    ;9E89: B6 82 23 
        STA     M821F                    ;9E8C: B7 82 1F 
        LDA     M8091                    ;9E8F: 96 91 
        BEQ     Z9E9B                    ;9E91: 27 08 
        CMPA    #$01                     ;9E93: 81 01 
        BNE     Z9E9F                    ;9E95: 26 08 
        LDA     #$02                     ;9E97: 86 02 
        BRA     Z9EFA                    ;9E99: 20 5F 
;------------------------------------------------------------------------
Z9E9B:	LDA     #$01                     ;9E9B: 86 01 
        BRA     Z9EFA                    ;9E9D: 20 5B 
;------------------------------------------------------------------------
Z9E9F:	LDA     M808C                    ;9E9F: 96 8C 
        BEQ     Z9EA7                    ;9EA1: 27 04 
        LDA     #$03                     ;9EA3: 86 03 
        BRA     Z9EFA                    ;9EA5: 20 53 
;------------------------------------------------------------------------
Z9EA7:	SWI                              ;9EA7: 3F 
;------------------------------------------------------------------------
Z9EA8:	CMPA    #$02                     ;9EA8: 81 02 
        BNE     Z9EC6                    ;9EAA: 26 1A 
        LDA     M8223                    ;9EAC: B6 82 23 
        STA     M821F                    ;9EAF: B7 82 1F 
        LDA     M8092                    ;9EB2: 96 92 
        BEQ     Z9EBE                    ;9EB4: 27 08 
        CMPA    #$01                     ;9EB6: 81 01 
        BNE     Z9EC2                    ;9EB8: 26 08 
        LDA     #$05                     ;9EBA: 86 05 
        BRA     Z9EFA                    ;9EBC: 20 3C 
;------------------------------------------------------------------------
Z9EBE:	LDA     #$04                     ;9EBE: 86 04 
        BRA     Z9EFA                    ;9EC0: 20 38 
;------------------------------------------------------------------------
Z9EC2:	LDA     #$06                     ;9EC2: 86 06 
        BRA     Z9EFA                    ;9EC4: 20 34 
;------------------------------------------------------------------------
Z9EC6:	CMPA    #$05                     ;9EC6: 81 05 
        BNE     Z9ECE                    ;9EC8: 26 04 
        LDA     #$07                     ;9ECA: 86 07 
        BRA     Z9ED4                    ;9ECC: 20 06 
;------------------------------------------------------------------------
Z9ECE:	CMPA    #$06                     ;9ECE: 81 06 
        BNE     Z9EDC                    ;9ED0: 26 0A 
        LDA     #$08                     ;9ED2: 86 08 
Z9ED4:	LDB     M8222                    ;9ED4: F6 82 22 
        STB     M821F                    ;9ED7: F7 82 1F 
        BRA     Z9EFA                    ;9EDA: 20 1E 
;------------------------------------------------------------------------
Z9EDC:	CMPA    #$07                     ;9EDC: 81 07 
        BNE     Z9EE9                    ;9EDE: 26 09 
        LDB     #$03                     ;9EE0: C6 03 
        STB     M821F                    ;9EE2: F7 82 1F 
        LDA     #$0A                     ;9EE5: 86 0A 
        BRA     Z9EFA                    ;9EE7: 20 11 
;------------------------------------------------------------------------
Z9EE9:	CMPA    #$09                     ;9EE9: 81 09 
        BNE     Z9EF2                    ;9EEB: 26 05 
        LDA     #$0B                     ;9EED: 86 0B 
        CLRB                             ;9EEF: 5F 
        BRA     Z9EFA                    ;9EF0: 20 08 
;------------------------------------------------------------------------
Z9EF2:	LDA     #$0F                     ;9EF2: 86 0F 
        STA     word_8007_X              ;9EF4: B7 80 07 
        JMP     Z9F1B                    ;9EF7: 7E 9F 1B 
;------------------------------------------------------------------------
Z9EFA:	LDB     M808C                    ;9EFA: D6 8C 
        CMPB    M821F                    ;9EFC: F1 82 1F 
        BLS     Z9F09                    ;9EFF: 23 08 
        LDA     #$0E                     ;9F01: 86 0E 
        STA     word_8007_X              ;9F03: B7 80 07 
        JMP     Z9F1B                    ;9F06: 7E 9F 1B 
;------------------------------------------------------------------------
Z9F09:	STD     M8220                    ;9F09: FD 82 20 
        JSR     Z9F60                    ;9F0C: BD 9F 60 
        LDD     M8220                    ;9F0F: FC 82 20 
        JSR     ZA435                    ;9F12: BD A4 35 
        BCS     Z9F1B                    ;9F15: 25 04 
        JSR     Z9F6F                    ;9F17: BD 9F 6F 
        RTS                              ;9F1A: 39 
;------------------------------------------------------------------------
Z9F1B:	JSR     Z9F6F                    ;9F1B: BD 9F 6F 
        LDA     word_8007_X              ;9F1E: B6 80 07 
        BEQ     Z9F5E                    ;9F21: 27 3B 
        CMPA    #$01                     ;9F23: 81 01 
        BNE     Z9F2C                    ;9F25: 26 05 
        LDD     #M7A9E                   ;9F27: CC 7A 9E 
        BRA     Z9F5B                    ;9F2A: 20 2F 
;------------------------------------------------------------------------
Z9F2C:	CMPA    #$02                     ;9F2C: 81 02 
        BCS     Z9F39                    ;9F2E: 25 09 
        CMPA    #$05                     ;9F30: 81 05 
        BHI     Z9F39                    ;9F32: 22 05 
        LDD     #M2A8E                   ;9F34: CC 2A 8E 
        BRA     Z9F5B                    ;9F37: 20 22 
;------------------------------------------------------------------------
Z9F39:	CMPA    #$06                     ;9F39: 81 06 
        BNE     Z9F42                    ;9F3B: 26 05 
        LDD     #M387A                   ;9F3D: CC 38 7A 
        BRA     Z9F5B                    ;9F40: 20 19 
;------------------------------------------------------------------------
Z9F42:	CMPA    #$07                     ;9F42: 81 07 
        BNE     Z9F4B                    ;9F44: 26 05 
        LDD     #M2A7A                   ;9F46: CC 2A 7A 
        BRA     Z9F5B                    ;9F49: 20 10 
;------------------------------------------------------------------------
Z9F4B:	CMPA    #$08                     ;9F4B: 81 08 
        BNE     Z9F54                    ;9F4D: 26 05 
        LDD     #MCE7A                   ;9F4F: CC CE 7A 
        BRA     Z9F5B                    ;9F52: 20 07 
;------------------------------------------------------------------------
Z9F54:	CMPA    #$09                     ;9F54: 81 09 
        BNE     Z9F5E                    ;9F56: 26 06 
        LDD     #M2A1A                   ;9F58: CC 2A 1A 
Z9F5B:	STD     M80B3                    ;9F5B: DD B3 
        RTS                              ;9F5D: 39 
;------------------------------------------------------------------------
Z9F5E:	BRA     Z9F5E                    ;9F5E: 20 FE 
;------------------------------------------------------------------------
Z9F60:	ORCC    #$50                     ;9F60: 1A 50 
        JSR     ZAB90                    ;9F62: BD AB 90 
        JSR     ROM_qchipsetup           ;9F65: BD F1 BB 
        JSR     Z8C80                    ;9F68: BD 8C 80 
        JSR     ROM_unknown3             ;9F6B: BD F5 41 
        RTS                              ;9F6E: 39 
;------------------------------------------------------------------------
Z9F6F:	ORCC    #$50                     ;9F6F: 1A 50 
        JSR     ROM_unknown3             ;9F71: BD F5 41 
        JSR     ROM_unknown2             ;9F74: BD F5 2D 
        JSR     task_handler_875e        ;9F77: BD 87 5E 
        JSR     kbd_init_parser          ;9F7A: BD 89 6B 
        JSR     MIDI_init_rxtx           ;9F7D: BD A0 7E 
        LDA     #$CC                     ;9F80: 86 CC 
        STA     VIA_aux                  ;9F82: B7 E2 0B 
        CLR     VIA_t1_lsb               ;9F85: 7F E2 06 
        CLR     VIA_t2_msb               ;9F88: 7F E2 07 
        CLR     VIA_t1c_lsb              ;9F8B: 7F E2 04 
        CLR     VIA_t1c_msb              ;9F8E: 7F E2 05 
        CLR     kdb_pedal_state_40       ;9F91: 0F 79 
        CLR     kbd_flag_damper_pedal_onoff ;9F93: 0F 6B 
        CLR     M8072                    ;9F95: 0F 72 
        ANDCC   #$AF                     ;9F97: 1C AF 
        RTS                              ;9F99: 39 
;------------------------------------------------------------------------
Z9F9A:	STA     M80BA                    ;9F9A: 97 BA 
        CMPA    #$0F                     ;9F9C: 81 0F 
        BNE     Z9FA4                    ;9F9E: 26 04 
        LDA     #$1C                     ;9FA0: 86 1C 
        BRA     Z9FA6                    ;9FA2: 20 02 
;------------------------------------------------------------------------
Z9FA4:	LDA     #$7C                     ;9FA4: 86 7C 
Z9FA6:	LDB     #$9C                     ;9FA6: C6 9C 
        STD     M80B3                    ;9FA8: DD B3 
        JSR     Z9431                    ;9FAA: BD 94 31 
        CLR     M808A                    ;9FAD: 0F 8A 
        LDB     #$06                     ;9FAF: C6 06 
        STB     M8082                    ;9FB1: D7 82 
        RTS                              ;9FB3: 39 
;------------------------------------------------------------------------
Z9FB4:	LDA     M80B7                    ;9FB4: 96 B7 
        LDB     #$24                     ;9FB6: C6 24 
        MUL                              ;9FB8: 3D 
        STD     M80B8                    ;9FB9: DD B8 
        JSR     Z99C2                    ;9FBB: BD 99 C2 
        TFR     Y,X                      ;9FBE: 1F 21 
        LDB     M80BA                    ;9FC0: D6 BA 
        BEQ     Z9FE6                    ;9FC2: 27 22 
        CMPB    #$0F                     ;9FC4: C1 0F 
        BNE     Z9FCF                    ;9FC6: 26 07 
        LDD     M80B8                    ;9FC8: DC B8 
        ADDD    #tab_b4fe_step36         ;9FCA: C3 B4 FE 
        BRA     Z9FD8                    ;9FCD: 20 09 
;------------------------------------------------------------------------
Z9FCF:	CMPB    #$10                     ;9FCF: C1 10 
        BNE     Z9FE6                    ;9FD1: 26 13 
        LDD     M80B8                    ;9FD3: DC B8 
        ADDD    #tab_b76f_step36         ;9FD5: C3 B7 6F 
Z9FD8:	TFR     D,U                      ;9FD8: 1F 03 
        LDA     #$00                     ;9FDA: 86 00 
        LDB     #$24                     ;9FDC: C6 24 
        TFR     D,Y                      ;9FDE: 1F 02 
        JSR     ROM_copybytes            ;9FE0: BD F5 5B 
        CLR     M80BA                    ;9FE3: 0F BA 
        RTS                              ;9FE5: 39 
;------------------------------------------------------------------------
Z9FE6:	LDD     #M2A3A                   ;9FE6: CC 2A 3A 
        STD     M80B3                    ;9FE9: DD B3 
        LDA     #$80                     ;9FEB: 86 80 
        STA     M80BA                    ;9FED: 97 BA 
        JSR     Z9431                    ;9FEF: BD 94 31 
        RTS                              ;9FF2: 39 
;------------------------------------------------------------------------

data_9ff3_via_U:
        FCB     $00,$00,$00,$00,$00,$00  ;9FF3: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$FF  ;9FF9: 00 00 00 00 00 FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$00  ;9FFF: FF FF FF FF FF 00 
        FCB     $00,$00,$00,$09,$0C,$3F  ;A005: 00 00 00 09 0C 3F 
        FCB     $20,$81,$07,$09,$8B,$80  ;A00B: 20 81 07 09 8B 80 
        FCB     $81,$01,$02,$03,$04,$05  ;A011: 81 01 02 03 04 05 
        FCB     $06,$07,$08,$00,$0C,$0D  ;A017: 06 07 08 00 0C 0D 
        FCB     $0E,$0F,$10,$11,$12,$13  ;A01D: 0E 0F 10 11 12 13 
        FCB     $14,$15,$16,$17,$18,$19  ;A023: 14 15 16 17 18 19 
        FCB     $1A,$1B,$1C,$1D,$1E,$1F  ;A029: 1A 1B 1C 1D 1E 1F 
        FCB     $4F,$50,$51,$52,$53,$88  ;A02F: 4F 50 51 52 53 88 
        FCB     $40,$09,$4A,$0B,$0C,$0D  ;A035: 40 09 4A 0B 0C 0D 
        FCB     $0E,$09,$09,$81,$09,$81  ;A03B: 0E 09 09 81 09 81 
        FCB     $09,$09,$09,$81,$0F,$81  ;A041: 09 09 09 81 0F 81 
        FCB     $03,$81,$81,$09,$81,$81  ;A047: 03 81 81 09 81 81 
        FCB     $00,$81,$81,$00,$00,$00  ;A04D: 00 81 81 00 00 00 
        FCB     $00,$40,$20,$40          ;A053: 00 40 20 40 

data_a057_via_X:
        FCB     $01,$63,$63,$63,$FC,$7C  ;A057: 01 63 63 63 FC 7C 
        FCB     $C6,$A0,$04,$07,$00,$01  ;A05D: C6 A0 04 07 00 01 
        FCB     $1F,$1F,$1F,$1F,$1F,$7C  ;A063: 1F 1F 1F 1F 1F 7C 
        FCB     $7C,$7C,$7C,$7C,$1F,$1F  ;A069: 7C 7C 7C 7C 1F 1F 
        FCB     $1F,$1F,$1F,$7C,$7C,$7C  ;A06F: 1F 1F 1F 7C 7C 7C 
        FCB     $7C,$7C                  ;A075: 7C 7C 

data_a077_via_U:
        FCB     $01,$07,$FF,$3F,$C6,$C6  ;A077: 01 07 FF 3F C6 C6 
        FCB     $3C                      ;A07D: 3C 
;------------------------------------------------------------------------

MIDI_init_rxtx:
        LDA     #$03                     ;A07E: 86 03 
        STA     UART_csr                 ;A080: B7 E1 00 
        LDA     #$95                     ;A083: 86 95 
        STA     UART_csr                 ;A085: B7 E1 00 
        LDD     #MIDI_txbuf_base         ;A088: CC 82 25 
        STD     MIDI_txbuf_msg_start     ;A08B: DD BC 
        STD     MIDI_txbuf_msg_end       ;A08D: DD BE 
        LDD     #UART_txhdlr             ;A08F: CC A1 BC 
        STD     ptr_UART_txhdlr          ;A092: DD C6 

MIDI_init_rx:
        LDD     #UART_rx_parser_exit     ;A094: CC A2 4A 
        STD     ptr_UART_rxhdlr          ;A097: DD C0 
        CLR     MIDI_txbuf_len           ;A099: 7F 82 35 
        CLR     MIDI_rxbuf_len           ;A09C: 7F 82 36 
        CLR     MIDI_rx_pending          ;A09F: 7F 82 37 
        RTS                              ;A0A2: 39 
;------------------------------------------------------------------------

MIDI_chk_msg_len_save:
        PSHS    U,D                      ;A0A3: 34 46 

MIDI_chk_msg_len:
        LDD     MIDI_txbuf_msg_start     ;A0A5: DC BC 
        SUBD    MIDI_txbuf_msg_end       ;A0A7: 93 BE 
        BPL     MIDI_chk_long_msg        ;A0A9: 2A 01 
        NEGB                             ;A0AB: 50 

MIDI_chk_long_msg:
        CMPB    #$08                     ;A0AC: C1 08 
        BLS     MIDI_chk_msg_exit        ;A0AE: 23 05 
        JSR     context_switch           ;A0B0: BD 88 5E 
        BRA     MIDI_chk_msg_len         ;A0B3: 20 F0 
;------------------------------------------------------------------------

MIDI_chk_msg_exit:
        PULS    PC,U,D                   ;A0B5: 35 C6 
;------------------------------------------------------------------------
ZA0B7:	BSR     MIDI_chk_msg_len_save    ;A0B7: 8D EA 

MIDI_do_note_on:
        PSHS    CC                       ;A0B9: 34 01 
        ORCC    #$50                     ;A0BB: 1A 50 
        STD     MIDI_txcmd_params        ;A0BD: DD C2 
        LDB     #$90                     ;A0BF: C6 90 
        BRA     MIDI_do_3byte_cmd        ;A0C1: 20 5F 
;------------------------------------------------------------------------
ZA0C3:	BSR     MIDI_chk_msg_len_save    ;A0C3: 8D DE 

MIDI_do_note_off:
        PSHS    CC                       ;A0C5: 34 01 
        ORCC    #$50                     ;A0C7: 1A 50 
        STD     MIDI_txcmd_params        ;A0C9: DD C2 
        LDB     #$80                     ;A0CB: C6 80 
        BRA     MIDI_do_3byte_cmd        ;A0CD: 20 53 
;------------------------------------------------------------------------

MIDI_set_pwheel_to_B:
        PSHS    CC                       ;A0CF: 34 01 
        ORCC    #$50                     ;A0D1: 1A 50 
        CLRA                             ;A0D3: 4F 
        STD     MIDI_txcmd_params        ;A0D4: DD C2 
        LDB     #$E0                     ;A0D6: C6 E0 
        BRA     ZA0EC                    ;A0D8: 20 12 
;------------------------------------------------------------------------

MIDI_set_pedal_to_B:
        PSHS    CC                       ;A0DA: 34 01 
        ORCC    #$50                     ;A0DC: 1A 50 
        LDA     #$40                     ;A0DE: 86 40 
        BRA     MIDI_do_ctrlr_msg        ;A0E0: 20 06 
;------------------------------------------------------------------------

MIDI_set_mwheel_to_B:
        PSHS    CC                       ;A0E2: 34 01 
        ORCC    #$50                     ;A0E4: 1A 50 
        LDA     #$01                     ;A0E6: 86 01 

MIDI_do_ctrlr_msg:
        STD     MIDI_txcmd_params        ;A0E8: DD C2 
        LDB     #$B0                     ;A0EA: C6 B0 
ZA0EC:	LDA     word_8023_X              ;A0EC: 96 23 
        BEQ     ZA134                    ;A0EE: 27 44 
        BRA     MIDI_do_3byte_cmd        ;A0F0: 20 30 
;------------------------------------------------------------------------
ZA0F2:	ORCC    #$50                     ;A0F2: 1A 50 
        LDA     word_8023_X              ;A0F4: 96 23 
        CMPA    #$02                     ;A0F6: 81 02 
        BEQ     MIDI_set_pchng_to_B      ;A0F8: 27 04 
        CMPA    #$03                     ;A0FA: 81 03 
        BNE     ZA10C                    ;A0FC: 26 0E 

MIDI_set_pchng_to_B:
        PSHS    B                        ;A0FE: 34 04 
        LDB     #$C0                     ;A100: C6 C0 
        STB     MIDI_cmd                 ;A102: D7 BB 
        ORB     MIDI_channel             ;A104: DA 21 
        BSR     MIDI_txbyte              ;A106: 8D 30 
        PULS    B                        ;A108: 35 04 
        BSR     MIDI_txbyte              ;A10A: 8D 2C 
ZA10C:	ANDCC   #$AF                     ;A10C: 1C AF 
ZA10E:	LDD     MIDI_txbuf_msg_start     ;A10E: DC BC 
        CMPD    MIDI_txbuf_msg_end       ;A110: 10 93 BE 
        BNE     ZA10E                    ;A113: 26 F9 
        RTS                              ;A115: 39 
;------------------------------------------------------------------------

MIDI_do_timing_clock:
        PSHS    CC                       ;A116: 34 01 
        ORCC    #$50                     ;A118: 1A 50 
        LDB     #$F8                     ;A11A: C6 F8 
        STB     MIDI_cmd                 ;A11C: D7 BB 
        BSR     MIDI_txbyte              ;A11E: 8D 18 
        PULS    PC,CC                    ;A120: 35 81 
;------------------------------------------------------------------------

MIDI_do_3byte_cmd:
        ORB     MIDI_channel             ;A122: DA 21 
        CMPB    MIDI_cmd                 ;A124: D1 BB 
        BEQ     ZA12C                    ;A126: 27 04 
        STB     MIDI_cmd                 ;A128: D7 BB 
        BSR     MIDI_txbyte              ;A12A: 8D 0C 
ZA12C:	LDB     MIDI_txcmd_params        ;A12C: D6 C2 
        BSR     MIDI_txbyte              ;A12E: 8D 08 
        LDB     MIDI_txcmd_param2        ;A130: D6 C3 
        BSR     MIDI_txbyte              ;A132: 8D 04 
ZA134:	LDD     MIDI_txcmd_params        ;A134: DC C2 
        PULS    PC,CC                    ;A136: 35 81 
;------------------------------------------------------------------------

MIDI_txbyte:
        LDA     MIDI_thru_enabled        ;A138: 96 22 
        BEQ     MIDI_byte_to_txbuf       ;A13A: 27 01 
        RTS                              ;A13C: 39 
;------------------------------------------------------------------------

MIDI_byte_to_txbuf:
        LDX     MIDI_txbuf_msg_start     ;A13D: 9E BC 
        STB     ,X+                      ;A13F: E7 80 
        CMPX    #MIDI_txbuf_len          ;A141: 8C 82 35 
        BCS     MIDI_txbuf_overflow      ;A144: 25 03 
        LDX     #MIDI_txbuf_base         ;A146: 8E 82 25 

MIDI_txbuf_overflow:
        STX     MIDI_txbuf_msg_start     ;A149: 9F BC 
        LDA     #$B5                     ;A14B: 86 B5 
        STA     UART_csr                 ;A14D: B7 E1 00 
        RTS                              ;A150: 39 
;------------------------------------------------------------------------

FIRQ_entry:
        PSHS    U,Y,X,D                  ;A151: 34 76 
        LDA     UART_csr                 ;A153: B6 E1 00 
        BPL     ZA1A9                    ;A156: 2A 51 
        BITA    #$30                     ;A158: 85 30 
        BEQ     ZA179                    ;A15A: 27 1D 
        LDA     MIDI_rx_pending          ;A15C: B6 82 37 
        BEQ     ZA163                    ;A15F: 27 02 
        STA     M80CE                    ;A161: 97 CE 
ZA163:	JSR     MIDI_init_rx             ;A163: BD A0 94 
        LDA     UART_data                ;A166: B6 E1 01 
        LDX     #vector_8076_X           ;A169: 8E 80 76 
        CLR     $03,X                    ;A16C: 6F 03 
        JSR     Z87DD                    ;A16E: BD 87 DD 
        LDX     #vector_8076_X           ;A171: 8E 80 76 
        JSR     Z87E2                    ;A174: BD 87 E2 
        BRA     ZA1A9                    ;A177: 20 30 
;------------------------------------------------------------------------
ZA179:	BITA    #$01                     ;A179: 85 01 
        BEQ     ZA1A5                    ;A17B: 27 28 
        BSR     ZA1DB                    ;A17D: 8D 5C 
ZA17F:	ORCC    #$40                     ;A17F: 1A 40 
        LDA     MIDI_rxbuf_len           ;A181: B6 82 36 
        CMPA    MIDI_txbuf_len           ;A184: B1 82 35 
        BEQ     ZA198                    ;A187: 27 0F 
        LDX     #MIDI_rxbuf_base         ;A189: 8E 82 38 
        LDB     A,X                      ;A18C: E6 86 
        INCA                             ;A18E: 4C 
        ANDA    #$3F                     ;A18F: 84 3F 
        STA     MIDI_rxbuf_len           ;A191: B7 82 36 
        BSR     ZA205                    ;A194: 8D 6F 
        BRA     ZA17F                    ;A196: 20 E7 
;------------------------------------------------------------------------
ZA198:	CLR     MIDI_rx_pending          ;A198: 7F 82 37 
        LDA     M80CE                    ;A19B: 96 CE 
        BEQ     ZA1A3                    ;A19D: 27 04 
        CLR     M80CE                    ;A19F: 0F CE 
        BRA     ZA163                    ;A1A1: 20 C0 
;------------------------------------------------------------------------
ZA1A3:	BRA     ZA1A9                    ;A1A3: 20 04 
;------------------------------------------------------------------------
ZA1A5:	BITA    #$02                     ;A1A5: 85 02 
        BNE     ZA1B6                    ;A1A7: 26 0D 
ZA1A9:	PULS    U,Y,X,D                  ;A1A9: 35 76 
        RTI                              ;A1AB: 3B 
;------------------------------------------------------------------------
ZA1AC:	PULS    D                        ;A1AC: 35 06 
        STD     ptr_UART_rxhdlr          ;A1AE: DD C0 
        RTS                              ;A1B0: 39 
;------------------------------------------------------------------------
        PULS    D                        ;A1B1: 35 06 
        STD     ptr_UART_txhdlr          ;A1B3: DD C6 
        RTS                              ;A1B5: 39 
;------------------------------------------------------------------------
ZA1B6:	JSR     [ptr_UART_txhdlr]        ;A1B6: AD 9F 80 C6 
        BRA     ZA1A9                    ;A1BA: 20 ED 
;------------------------------------------------------------------------

UART_txhdlr:
        LDX     MIDI_txbuf_msg_end       ;A1BC: 9E BE 
        LDA     ,X+                      ;A1BE: A6 80 
        STA     UART_data                ;A1C0: B7 E1 01 
        CMPX    #MIDI_txbuf_len          ;A1C3: 8C 82 35 
        BCS     ZA1CB                    ;A1C6: 25 03 
        LDX     #MIDI_txbuf_base         ;A1C8: 8E 82 25 
ZA1CB:	CMPX    MIDI_txbuf_msg_start     ;A1CB: 9C BC 
        BNE     ZA1D8                    ;A1CD: 26 09 
        LDA     MIDI_thru_enabled        ;A1CF: 96 22 
        BNE     ZA1D3                    ;A1D1: 26 00 
ZA1D3:	LDB     #$95                     ;A1D3: C6 95 
        STB     UART_csr                 ;A1D5: F7 E1 00 
ZA1D8:	STX     MIDI_txbuf_msg_end       ;A1D8: 9F BE 
        RTS                              ;A1DA: 39 
;------------------------------------------------------------------------
ZA1DB:	LDB     UART_data                ;A1DB: F6 E1 01 
        LDA     MIDI_rx_pending          ;A1DE: B6 82 37 
        BEQ     ZA202                    ;A1E1: 27 1F 
        LDA     MIDI_txbuf_len           ;A1E3: B6 82 35 
        LDX     #MIDI_rxbuf_base         ;A1E6: 8E 82 38 
        STB     A,X                      ;A1E9: E7 86 
        INCA                             ;A1EB: 4C 
        ANDA    #$3F                     ;A1EC: 84 3F 
        STA     MIDI_txbuf_len           ;A1EE: B7 82 35 
        CMPA    MIDI_rxbuf_len           ;A1F1: B1 82 36 
        BNE     ZA1FB                    ;A1F4: 26 05 
        LEAS    $02,S                    ;A1F6: 32 62 
        JMP     ZA163                    ;A1F8: 7E A1 63 
;------------------------------------------------------------------------
ZA1FB:	LEAS    $02,S                    ;A1FB: 32 62 
        PULS    U,Y,X,D                  ;A1FD: 35 76 
        RTI                              ;A1FF: 3B 
;------------------------------------------------------------------------
        BRA     ZA205                    ;A200: 20 03 
;------------------------------------------------------------------------
ZA202:	INC     MIDI_rx_pending          ;A202: 7C 82 37 
ZA205:	LDA     MIDI_thru_enabled        ;A205: 96 22 
        BEQ     ZA20C                    ;A207: 27 03 
        JSR     MIDI_byte_to_txbuf       ;A209: BD A1 3D 
ZA20C:	ANDCC   #$BF                     ;A20C: 1C BF 
        TSTB                             ;A20E: 5D 
        BMI     UART_rx_chk_for_cmd      ;A20F: 2B 04 
        JMP     [ptr_UART_rxhdlr]        ;A211: 6E 9F 80 C0 
;------------------------------------------------------------------------

UART_rx_chk_for_cmd:
        STB     MIDI_rxcmd               ;A215: D7 C5 
        ANDB    #$70                     ;A217: C4 70 
        CMPB    #$70                     ;A219: C1 70 
        BEQ     ZA23D                    ;A21B: 27 20 
        LDB     MIDI_rxcmd               ;A21D: D6 C5 
        ANDB    #$0F                     ;A21F: C4 0F 
        STB     MIDI_rxcmd_channel       ;A221: D7 C4 
        LDA     word_8020_X              ;A223: 96 20 
        BNE     UART_rx_channel_message  ;A225: 26 07 
        CMPB    MIDI_channel             ;A227: D1 21 
        BEQ     UART_rx_channel_message  ;A229: 27 03 
        JMP     UART_rx_skip_message     ;A22B: 7E A2 47 
;------------------------------------------------------------------------

UART_rx_channel_message:
        LDB     MIDI_rxcmd               ;A22E: D6 C5 
        ANDB    #$70                     ;A230: C4 70 
        ASRB                             ;A232: 57 
        ASRB                             ;A233: 57 
        ASRB                             ;A234: 57 
        LDX     #MIDI_rx_vec_chnlmsg_parsers ;A235: 8E A3 D4 
        LDD     B,X                      ;A238: EC 85 
        STD     ptr_UART_rxhdlr          ;A23A: DD C0 
        RTS                              ;A23C: 39 
;------------------------------------------------------------------------
ZA23D:	LDB     MIDI_rxcmd               ;A23D: D6 C5 
        ANDB    #$0F                     ;A23F: C4 0F 
        LDX     #MIDI_rx_vec_systmsg_parsers ;A241: 8E A3 E4 
        ASLB                             ;A244: 58 
        JMP     [B,X]                    ;A245: 6E 95 
;------------------------------------------------------------------------

UART_rx_skip_message:
        JSR     ZA1AC                    ;A247: BD A1 AC 

UART_rx_parser_exit:
        RTS                              ;A24A: 39 
;------------------------------------------------------------------------

UART_rx_parser_note_off:
        BSR     ZA290                    ;A24B: 8D 43 
        JSR     ZA1AC                    ;A24D: BD A1 AC 
        LDU     #UART_rx_parser_note_off ;A250: CE A2 4B 
        STU     ptr_UART_rxhdlr          ;A253: DF C0 
        CMPB    #$00                     ;A255: C1 00 
        BNE     ZA25B                    ;A257: 26 02 
        LDB     #$40                     ;A259: C6 40 
ZA25B:	LDA     MIDI_rxcmd_channel       ;A25B: 96 C4 
        JSR     ZADBC                    ;A25D: BD AD BC 
        LDA     MIDI_rxcmd_channel       ;A260: 96 C4 
        LDX     #vector_8076_X           ;A262: 8E 80 76 
        JMP     Z87BF                    ;A265: 7E 87 BF 
;------------------------------------------------------------------------

UART_rx_parser_note_on:
        BSR     ZA290                    ;A268: 8D 26 
        JSR     ZA1AC                    ;A26A: BD A1 AC 
        LDU     #UART_rx_parser_note_on  ;A26D: CE A2 68 
        STU     ptr_UART_rxhdlr          ;A270: DF C0 
        LDA     MIDI_rxcmd_channel       ;A272: 96 C4 
        CMPB    #$00                     ;A274: C1 00 
        BNE     ZA285                    ;A276: 26 0D 
        LDB     #$40                     ;A278: C6 40 
        JSR     ZADBC                    ;A27A: BD AD BC 
        LDA     MIDI_rxcmd_channel       ;A27D: 96 C4 
        LDX     #vector_8076_X           ;A27F: 8E 80 76 
        JMP     Z87BF                    ;A282: 7E 87 BF 
;------------------------------------------------------------------------
ZA285:	JSR     adba_note_on_jsr         ;A285: BD AD BA 
        LDA     MIDI_rxcmd_channel       ;A288: 96 C4 
        LDX     #vector_8076_X           ;A28A: 8E 80 76 
        JMP     Z87C4                    ;A28D: 7E 87 C4 
;------------------------------------------------------------------------
ZA290:	CMPB    #$24                     ;A290: C1 24 
        BCC     ZA298                    ;A292: 24 04 
        ADDB    #$0C                     ;A294: CB 0C 
        BRA     ZA290                    ;A296: 20 F8 
;------------------------------------------------------------------------
ZA298:	CMPB    #$60                     ;A298: C1 60 
        BLS     ZA2A0                    ;A29A: 23 04 
        SUBB    #$0C                     ;A29C: C0 0C 
        BRA     ZA298                    ;A29E: 20 F8 
;------------------------------------------------------------------------
ZA2A0:	STB     MIDI_rxcmd_channel       ;A2A0: D7 C4 
        RTS                              ;A2A2: 39 
;------------------------------------------------------------------------

UART_rx_parser_ctrlr:
        CMPB    #$40                     ;A2A3: C1 40 
        BNE     ZA2AD                    ;A2A5: 26 06 
        LDD     #code_a32b_via_D         ;A2A7: CC A3 2B 
        STD     ptr_UART_rxhdlr          ;A2AA: DD C0 
        RTS                              ;A2AC: 39 
;------------------------------------------------------------------------
ZA2AD:	CMPB    #$60                     ;A2AD: C1 60 
        BNE     ZA2C2                    ;A2AF: 26 11 
        LDA     M80CD                    ;A2B1: 96 CD 
        CMPA    #$80                     ;A2B3: 81 80 
        BCS     ZA2C2                    ;A2B5: 25 0B 
        JSR     pedal_handler_if_8028_not_zero ;A2B7: BD A4 04 
        CLR     M80CD                    ;A2BA: 0F CD 
        JSR     ZA1AC                    ;A2BC: BD A1 AC 
        JMP     ZA341                    ;A2BF: 7E A3 41 
;------------------------------------------------------------------------
ZA2C2:	CMPB    word_801d_X              ;A2C2: D1 1D 
        BEQ     ZA2CA                    ;A2C4: 27 04 
        CMPB    word_801e_X              ;A2C6: D1 1E 
        BNE     ZA2D2                    ;A2C8: 26 08 
ZA2CA:	STB     MIDI_rxcmd_channel       ;A2CA: D7 C4 
        LDD     #code_a30d_via_D         ;A2CC: CC A3 0D 
        STD     ptr_UART_rxhdlr          ;A2CF: DD C0 
        RTS                              ;A2D1: 39 
;------------------------------------------------------------------------
ZA2D2:	LDU     #ZA341                   ;A2D2: CE A3 41 
        STU     ptr_UART_rxhdlr          ;A2D5: DF C0 
        LDA     MIDI_channel             ;A2D7: 96 21 
        CMPA    MIDI_rxcmd_channel       ;A2D9: 91 C4 
        BNE     ZA2ED                    ;A2DB: 26 10 
        CMPB    #$7C                     ;A2DD: C1 7C 
        BNE     ZA2E5                    ;A2DF: 26 04 
        CLR     word_8020_X              ;A2E1: 0F 20 
        BRA     ZA2F1                    ;A2E3: 20 0C 
;------------------------------------------------------------------------
ZA2E5:	CMPB    #$7D                     ;A2E5: C1 7D 
        BNE     ZA2ED                    ;A2E7: 26 04 
        STB     word_8020_X              ;A2E9: D7 20 

UART_rx_system_message:
        BRA     ZA2F1                    ;A2EB: 20 04 
;------------------------------------------------------------------------
ZA2ED:	CMPB    #$7B                     ;A2ED: C1 7B 
        BNE     ZA2F7                    ;A2EF: 26 06 
ZA2F1:	LDX     #vector_8076_X           ;A2F1: 8E 80 76 
        JMP     Z87E2                    ;A2F4: 7E 87 E2 
;------------------------------------------------------------------------
ZA2F7:	RTS                              ;A2F7: 39 
;------------------------------------------------------------------------

UART_rx_parser_pitbend:
        JSR     ZA1AC                    ;A2F8: BD A1 AC 
        LDU     #UART_rx_parser_pitbend  ;A2FB: CE A2 F8 
        STU     ptr_UART_rxhdlr          ;A2FE: DF C0 
        LDA     word_8023_X              ;A300: 96 23 
        BEQ     ZA30C                    ;A302: 27 08 
        JSR     ZADAF                    ;A304: BD AD AF 
        JSR     Z90C0                    ;A307: BD 90 C0 
        STD     M8077                    ;A30A: DD 77 
ZA30C:	RTS                              ;A30C: 39 
;------------------------------------------------------------------------

code_a30d_via_D:
        BSR     ZA341                    ;A30D: 8D 32 
        LDA     word_8023_X              ;A30F: 96 23 
        BEQ     ZA32A                    ;A311: 27 17 
        LDA     MIDI_rxcmd_channel       ;A313: 96 C4 
        BEQ     ZA32A                    ;A315: 27 13 
        CMPA    #$08                     ;A317: 81 08 
        BCC     ZA32A                    ;A319: 24 0F 
        CMPA    word_801e_X              ;A31B: 91 1E 
        BNE     ZA321                    ;A31D: 26 02 
        STB     vector_8076_X            ;A31F: D7 76 
ZA321:	CMPA    word_801d_X              ;A321: 91 1D 
        BNE     ZA32A                    ;A323: 26 05 
        STB     M807A                    ;A325: D7 7A 
        JSR     ZADB2                    ;A327: BD AD B2 
ZA32A:	RTS                              ;A32A: 39 
;------------------------------------------------------------------------

code_a32b_via_D:
        BSR     ZA341                    ;A32B: 8D 14 
        LDA     word_8023_X              ;A32D: 96 23 
        BEQ     ZA340                    ;A32F: 27 0F 
        JSR     pedal_handler_2          ;A331: BD AD B6 
        ANDB    #$40                     ;A334: C4 40 
        STB     kdb_pedal_state_40       ;A336: D7 79 
        BNE     ZA340                    ;A338: 26 06 
        LDX     #vector_8076_X           ;A33A: 8E 80 76 
        JSR     Z87DD                    ;A33D: BD 87 DD 
ZA340:	RTS                              ;A340: 39 
;------------------------------------------------------------------------
ZA341:	LDU     #UART_rx_parser_ctrlr    ;A341: CE A2 A3 
        STU     ptr_UART_rxhdlr          ;A344: DF C0 
        RTS                              ;A346: 39 
;------------------------------------------------------------------------
ZA347:	JSR     ZA1AC                    ;A347: BD A1 AC 

UART_rx_parser_chnlprs:
        LDA     word_8023_X              ;A34A: 96 23 
        LBEQ    UART_rx_skip_message     ;A34C: 10 27 FE F7 
        ASLB                             ;A350: 58 
        LDA     word_801f_X              ;A351: 96 1F 
        MUL                              ;A353: 3D 
        TFR     A,B                      ;A354: 1F 89 
        LDA     word_801d_X              ;A356: 96 1D 
        CMPA    #$08                     ;A358: 81 08 
        BNE     ZA35E                    ;A35A: 26 02 
        STB     M807A                    ;A35C: D7 7A 
ZA35E:	LDA     word_801e_X              ;A35E: 96 1E 
        CMPA    #$08                     ;A360: 81 08 
        BNE     ZA366                    ;A362: 26 02 
        STB     vector_8076_X            ;A364: D7 76 
ZA366:	BRA     ZA347                    ;A366: 20 DF 
;------------------------------------------------------------------------
ZA368:	JSR     ZA1AC                    ;A368: BD A1 AC 

UART_rx_parser_polyprs:
        LDA     word_8023_X              ;A36B: 96 23 
        LBEQ    UART_rx_skip_message     ;A36D: 10 27 FE D6 
        STB     MIDI_rxcmd_channel       ;A371: D7 C4 
        JSR     ZA1AC                    ;A373: BD A1 AC 
        ASLB                             ;A376: 58 
        LDA     word_801f_X              ;A377: 96 1F 
        MUL                              ;A379: 3D 
        TFR     A,B                      ;A37A: 1F 89 
        LDA     word_801d_X              ;A37C: 96 1D 
        CMPA    #$09                     ;A37E: 81 09 
        BEQ     ZA388                    ;A380: 27 06 
        LDA     word_801e_X              ;A382: 96 1E 
        CMPA    #$09                     ;A384: 81 09 
        BNE     ZA390                    ;A386: 26 08 
ZA388:	LDA     MIDI_rxcmd_channel       ;A388: 96 C4 
        LDX     #vector_8076_X           ;A38A: 8E 80 76 
        JSR     Z87D8                    ;A38D: BD 87 D8 
ZA390:	BRA     ZA368                    ;A390: 20 D6 
;------------------------------------------------------------------------
ZA392:	JSR     ZA1AC                    ;A392: BD A1 AC 

UART_rx_parser_progchn:
        CMPB    #$2F                     ;A395: C1 2F 
        BHI     ZA392                    ;A397: 22 F9 
        ORB     #$80                     ;A399: CA 80 
        LDA     word_8023_X              ;A39B: 96 23 
        CMPA    #$02                     ;A39D: 81 02 
        BNE     ZA3A8                    ;A39F: 26 07 
        TFR     B,A                      ;A3A1: 1F 98 
        JSR     pedal_handler_if_8028_not_zero ;A3A3: BD A4 04 
        BRA     ZA3AE                    ;A3A6: 20 06 
;------------------------------------------------------------------------
ZA3A8:	CMPA    #$03                     ;A3A8: 81 03 
        BNE     ZA3AE                    ;A3AA: 26 02 
        STB     M80CD                    ;A3AC: D7 CD 
ZA3AE:	BRA     ZA392                    ;A3AE: 20 E2 
;------------------------------------------------------------------------

UART_rx_parser_timing_clk:
        LDA     word_8025_X              ;A3B0: 96 25 
        BNE     ZA3BD                    ;A3B2: 26 09 
        LDA     word_8024_X              ;A3B4: 96 24 
        BEQ     ZA3BD                    ;A3B6: 27 05 
        INC     M80E9                    ;A3B8: 0C E9 
        JSR     MIDI_do_timing_clock     ;A3BA: BD A1 16 
ZA3BD:	RTS                              ;A3BD: 39 
;------------------------------------------------------------------------

UART_rx_parser_seq_start:
        LDA     #$1C                     ;A3BE: 86 1C 
        BRA     ZA3C8                    ;A3C0: 20 06 
;------------------------------------------------------------------------

UART_rx_parser_seq_stop:
        LDA     #$1E                     ;A3C2: 86 1E 
        BRA     ZA3C8                    ;A3C4: 20 02 
;------------------------------------------------------------------------

UART_rx_parser_seq_cont:
        LDA     #$1D                     ;A3C6: 86 1D 
ZA3C8:	LDB     word_8024_X              ;A3C8: D6 24 
        BEQ     UART_rx_parser_sense_rst ;A3CA: 27 07 
        LDB     word_8025_X              ;A3CC: D6 25 
        BNE     UART_rx_parser_sense_rst ;A3CE: 26 03 
        JSR     pedal_handler_if_8028_not_zero ;A3D0: BD A4 04 

UART_rx_parser_sense_rst:
        RTS                              ;A3D3: 39 
;------------------------------------------------------------------------

MIDI_rx_vec_chnlmsg_parsers:
        FDB     UART_rx_parser_note_off  ;A3D4: A2 4B 
        FDB     UART_rx_parser_note_on   ;A3D6: A2 68 
        FDB     UART_rx_parser_polyprs   ;A3D8: A3 6B 
        FDB     UART_rx_parser_ctrlr     ;A3DA: A2 A3 
        FDB     UART_rx_parser_progchn   ;A3DC: A3 95 
        FDB     UART_rx_parser_chnlprs   ;A3DE: A3 4A 
        FDB     UART_rx_parser_pitbend   ;A3E0: A2 F8 
        FDB     UART_rx_parser_exit      ;A3E2: A2 4A 

MIDI_rx_vec_systmsg_parsers:
        FDB     UART_rx_skip_message     ;A3E4: A2 47 
        FDB     UART_rx_skip_message     ;A3E6: A2 47 
        FDB     UART_rx_skip_message     ;A3E8: A2 47 
        FDB     UART_rx_skip_message     ;A3EA: A2 47 
        FDB     UART_rx_skip_message     ;A3EC: A2 47 
        FDB     UART_rx_skip_message     ;A3EE: A2 47 
        FDB     UART_rx_skip_message     ;A3F0: A2 47 
        FDB     UART_rx_skip_message     ;A3F2: A2 47 
        FDB     UART_rx_parser_timing_clk ;A3F4: A3 B0 
        FDB     UART_rx_skip_message     ;A3F6: A2 47 
        FDB     UART_rx_parser_seq_start ;A3F8: A3 BE 
        FDB     UART_rx_parser_seq_cont  ;A3FA: A3 C6 
        FDB     UART_rx_parser_seq_stop  ;A3FC: A3 C2 
        FDB     UART_rx_skip_message     ;A3FE: A2 47 
        FDB     UART_rx_parser_sense_rst ;A400: A3 D3 
        FDB     UART_rx_parser_sense_rst ;A402: A3 D3 
;------------------------------------------------------------------------

pedal_handler_if_8028_not_zero:
        PSHS    CC                       ;A404: 34 01 
        ORCC    #$10                     ;A406: 1A 10 
        LDX     vec_to_8280_seemingly_static ;A408: BE 82 78 
        STA     ,X+                      ;A40B: A7 80 
        CMPX    #Z828C                   ;A40D: 8C 82 8C 
        BCS     ZA415                    ;A410: 25 03 
        LDX     #table_10_11_01_0a       ;A412: 8E 82 7C 
ZA415:	STX     vec_to_8280_seemingly_static ;A415: BF 82 78 
        PULS    PC,CC                    ;A418: 35 81 
;------------------------------------------------------------------------
ZA41A:	LDX     vec_to_827c_seemingly_static ;A41A: BE 82 7A 
        CMPX    vec_to_8280_seemingly_static ;A41D: BC 82 78 
        BNE     ZA425                    ;A420: 26 03 
        ANDCC   #$FE                     ;A422: 1C FE 
        RTS                              ;A424: 39 
;------------------------------------------------------------------------
ZA425:	LDA     ,X+                      ;A425: A6 80 
        CMPX    #Z828C                   ;A427: 8C 82 8C 
        BCS     ZA42F                    ;A42A: 25 03 
        LDX     #table_10_11_01_0a       ;A42C: 8E 82 7C 
ZA42F:	STX     vec_to_827c_seemingly_static ;A42F: BF 82 7A 
        ORCC    #$01                     ;A432: 1A 01 
        RTS                              ;A434: 39 
;------------------------------------------------------------------------
ZA435:	JSR     ZA4BA                    ;A435: BD A4 BA 
        LDA     word_8007_X              ;A438: B6 80 07 
        CMPA    #$00                     ;A43B: 81 00 
        BEQ     ZA442                    ;A43D: 27 03 
        LBRA    ZA4A6                    ;A43F: 16 00 64 
ZA442:	LDA     MIDI_program_number      ;A442: B6 80 CF 
        CMPA    #$01                     ;A445: 81 01 
        BNE     ZA44E                    ;A447: 26 05 
        JSR     load_samples             ;A449: BD A4 D4 
        BRA     ZA4A6                    ;A44C: 20 58 
;------------------------------------------------------------------------
ZA44E:	CMPA    #$02                     ;A44E: 81 02 
        BNE     ZA457                    ;A450: 26 05 
        JSR     load_samples             ;A452: BD A4 D4 
        BRA     ZA4A6                    ;A455: 20 4F 
;------------------------------------------------------------------------
ZA457:	CMPA    #$03                     ;A457: 81 03 
        BNE     ZA460                    ;A459: 26 05 
        JSR     load_samples             ;A45B: BD A4 D4 
        BRA     ZA4A6                    ;A45E: 20 46 
;------------------------------------------------------------------------
ZA460:	CMPA    #$04                     ;A460: 81 04 
        BNE     ZA469                    ;A462: 26 05 
        JSR     ZA53A                    ;A464: BD A5 3A 
        BRA     ZA4A6                    ;A467: 20 3D 
;------------------------------------------------------------------------
ZA469:	CMPA    #$05                     ;A469: 81 05 
        BNE     ZA472                    ;A46B: 26 05 
        JSR     ZA53A                    ;A46D: BD A5 3A 
        BRA     ZA4A6                    ;A470: 20 34 
;------------------------------------------------------------------------
ZA472:	CMPA    #$06                     ;A472: 81 06 
        BNE     ZA47B                    ;A474: 26 05 
        JSR     ZA53A                    ;A476: BD A5 3A 
        BRA     ZA4A6                    ;A479: 20 2B 
;------------------------------------------------------------------------
ZA47B:	CMPA    #$07                     ;A47B: 81 07 
        BNE     ZA484                    ;A47D: 26 05 
        JSR     ZA5A1                    ;A47F: BD A5 A1 
        BRA     ZA4A6                    ;A482: 20 22 
;------------------------------------------------------------------------
ZA484:	CMPA    #$08                     ;A484: 81 08 
        BNE     ZA48D                    ;A486: 26 05 
        JSR     ZA5FC                    ;A488: BD A5 FC 
        BRA     ZA4A6                    ;A48B: 20 19 
;------------------------------------------------------------------------
ZA48D:	CMPA    #$09                     ;A48D: 81 09 
        BNE     ZA496                    ;A48F: 26 05 
        JSR     ZA5A1                    ;A491: BD A5 A1 
        BRA     ZA4A6                    ;A494: 20 10 
;------------------------------------------------------------------------
ZA496:	CMPA    #$0A                     ;A496: 81 0A 
        BNE     ZA49F                    ;A498: 26 05 
        JSR     ZA5FC                    ;A49A: BD A5 FC 
        BRA     ZA4A6                    ;A49D: 20 07 
;------------------------------------------------------------------------
ZA49F:	CMPA    #$0B                     ;A49F: 81 0B 
        BNE     ZA4A6                    ;A4A1: 26 03 
        JSR     ZA653                    ;A4A3: BD A6 53 
ZA4A6:	LDA     FDC_track                ;A4A6: B6 E8 01 
        STA     M8002                    ;A4A9: B7 80 02 
        LDA     word_8007_X              ;A4AC: B6 80 07 
        CMPA    #$00                     ;A4AF: 81 00 
        BNE     ZA4B7                    ;A4B1: 26 04 
        ANDCC   #$FE                     ;A4B3: 1C FE 
        BRA     ZA4B9                    ;A4B5: 20 02 
;------------------------------------------------------------------------
ZA4B7:	ORCC    #$01                     ;A4B7: 1A 01 
ZA4B9:	RTS                              ;A4B9: 39 
;------------------------------------------------------------------------
ZA4BA:	STA     MIDI_program_number      ;A4BA: B7 80 CF 
        STB     M80D0                    ;A4BD: F7 80 D0 
        JSR     ZAB20                    ;A4C0: BD AB 20 
        CLR     word_8007_X              ;A4C3: 7F 80 07 
        LDA     #$E8                     ;A4C6: 86 E8 
        TFR     A,DP                     ;A4C8: 1F 8B 
        JSR     ROM_fdcforceinterrupt    ;A4CA: BD F0 8F 
        LDA     M8002                    ;A4CD: B6 80 02 
        STA     FDC_track                ;A4D0: B7 E8 01 
        RTS                              ;A4D3: 39 
;------------------------------------------------------------------------

load_samples:
        JSR     ROM_enablefd             ;A4D4: BD F4 C6 
        LDA     #$40                     ;A4D7: 86 40 
        ANDA    VIA_dr_b                 ;A4D9: B4 E2 00 
        CMPA    #$00                     ;A4DC: 81 00 
        BNE     ZA4E8                    ;A4DE: 26 08 
        LDA     #$07                     ;A4E0: 86 07 
        STA     word_8007_X              ;A4E2: B7 80 07 
        LBRA    ZA536                    ;A4E5: 16 00 4E 
ZA4E8:	JSR     ZA8B9                    ;A4E8: BD A8 B9 
        LDA     word_8007_X              ;A4EB: B6 80 07 
        CMPA    #$00                     ;A4EE: 81 00 
        BEQ     ZA4F5                    ;A4F0: 27 03 
        LBRA    ZA536                    ;A4F2: 16 00 41 
ZA4F5:	CLR     M80E1                    ;A4F5: 7F 80 E1 
        CLR     M80E3                    ;A4F8: 7F 80 E3 
        LDA     MIDI_program_number      ;A4FB: B6 80 CF 
        CMPA    #$01                     ;A4FE: 81 01 
        BEQ     ZA509                    ;A500: 27 07 
        LDA     MIDI_program_number      ;A502: B6 80 CF 
        CMPA    #$03                     ;A505: 81 03 
        BNE     ZA51D                    ;A507: 26 14 
ZA509:	LDA     VIA_dr_b                 ;A509: B6 E2 00 
        ANDA    #$FC                     ;A50C: 84 FC 
        STA     VIA_dr_b                 ;A50E: B7 E2 00 
        JSR     ZA69C                    ;A511: BD A6 9C 
        LDA     word_8006_X              ;A514: B6 80 06 
        CMPA    #$00                     ;A517: 81 00 
        BEQ     ZA51D                    ;A519: 27 02 
        BRA     ZA536                    ;A51B: 20 19 
;------------------------------------------------------------------------
ZA51D:	LDA     MIDI_program_number      ;A51D: B6 80 CF 
        CMPA    #$02                     ;A520: 81 02 
        BEQ     ZA52B                    ;A522: 27 07 
        LDA     MIDI_program_number      ;A524: B6 80 CF 
        CMPA    #$03                     ;A527: 81 03 
        BNE     ZA536                    ;A529: 26 0B 
ZA52B:	LDA     VIA_dr_b                 ;A52B: B6 E2 00 
        ANDA    #$FC                     ;A52E: 84 FC 
        STA     VIA_dr_b                 ;A530: B7 E2 00 
        JSR     ZA6E8                    ;A533: BD A6 E8 
ZA536:	JSR     ROM_disablefd            ;A536: BD F4 D6 
        RTS                              ;A539: 39 
;------------------------------------------------------------------------
ZA53A:	JSR     ROM_enablefd             ;A53A: BD F4 C6 
        LDA     #$40                     ;A53D: 86 40 
        ANDA    VIA_dr_b                 ;A53F: B4 E2 00 
        CMPA    #$00                     ;A542: 81 00 
        BNE     ZA54E                    ;A544: 26 08 
        LDA     #$07                     ;A546: 86 07 
        STA     word_8007_X              ;A548: B7 80 07 
        LBRA    ZA59D                    ;A54B: 16 00 4F 
ZA54E:	LDA     #$02                     ;A54E: 86 02 
        STA     M80E1                    ;A550: B7 80 E1 
        CLR     M80E3                    ;A553: 7F 80 E3 
        LDA     MIDI_program_number      ;A556: B6 80 CF 
        CMPA    #$04                     ;A559: 81 04 
        BEQ     ZA564                    ;A55B: 27 07 
        LDA     MIDI_program_number      ;A55D: B6 80 CF 
        CMPA    #$06                     ;A560: 81 06 
        BNE     ZA578                    ;A562: 26 14 
ZA564:	LDA     VIA_dr_b                 ;A564: B6 E2 00 
        ANDA    #$FC                     ;A567: 84 FC 
        STA     VIA_dr_b                 ;A569: B7 E2 00 
        JSR     ZA69C                    ;A56C: BD A6 9C 
        LDA     word_8006_X              ;A56F: B6 80 06 
        CMPA    #$00                     ;A572: 81 00 
        BEQ     ZA578                    ;A574: 27 02 
        BRA     ZA59D                    ;A576: 20 25 
;------------------------------------------------------------------------
ZA578:	LDA     MIDI_program_number      ;A578: B6 80 CF 
        CMPA    #$05                     ;A57B: 81 05 
        BEQ     ZA586                    ;A57D: 27 07 
        LDA     MIDI_program_number      ;A57F: B6 80 CF 
        CMPA    #$06                     ;A582: 81 06 
        BNE     ZA59A                    ;A584: 26 14 
ZA586:	LDA     VIA_dr_b                 ;A586: B6 E2 00 
        ANDA    #$FC                     ;A589: 84 FC 
        STA     VIA_dr_b                 ;A58B: B7 E2 00 
        JSR     ZA6E8                    ;A58E: BD A6 E8 
        LDA     word_8006_X              ;A591: B6 80 06 
        CMPA    #$00                     ;A594: 81 00 
        BEQ     ZA59A                    ;A596: 27 02 
        BRA     ZA59D                    ;A598: 20 03 
;------------------------------------------------------------------------
ZA59A:	JSR     ZA97C                    ;A59A: BD A9 7C 
ZA59D:	JSR     ROM_disablefd            ;A59D: BD F4 D6 
        RTS                              ;A5A0: 39 
;------------------------------------------------------------------------
ZA5A1:	JSR     ROM_enablefd             ;A5A1: BD F4 C6 
        LDA     #$40                     ;A5A4: 86 40 
        ANDA    VIA_dr_b                 ;A5A6: B4 E2 00 
        CMPA    #$00                     ;A5A9: 81 00 
        BNE     ZA5B5                    ;A5AB: 26 08 
        LDA     #$07                     ;A5AD: 86 07 
        STA     word_8007_X              ;A5AF: B7 80 07 
        LBRA    ZA5F8                    ;A5B2: 16 00 43 
ZA5B5:	JSR     ZA8B9                    ;A5B5: BD A8 B9 
        LDA     word_8007_X              ;A5B8: B6 80 07 
        CMPA    #$00                     ;A5BB: 81 00 
        BEQ     ZA5C1                    ;A5BD: 27 02 
        BRA     ZA5F8                    ;A5BF: 20 37 
;------------------------------------------------------------------------
ZA5C1:	LDA     MIDI_program_number      ;A5C1: B6 80 CF 
        CMPA    #$07                     ;A5C4: 81 07 
        BNE     ZA5CE                    ;A5C6: 26 06 
        LDY     #ROM_ts_shortseq         ;A5C8: 10 8E FB A8 
        BRA     ZA5D6                    ;A5CC: 20 08 
;------------------------------------------------------------------------
ZA5CE:	CMPA    #$09                     ;A5CE: 81 09 
        BNE     ZA5D6                    ;A5D0: 26 04 
        LDY     #ROM_ts_longseq          ;A5D2: 10 8E FB C8 
ZA5D6:	CLR     M80E3                    ;A5D6: 7F 80 E3 
        JSR     ZAAD2                    ;A5D9: BD AA D2 
        LDA     word_8006_X              ;A5DC: B6 80 06 
        CMPA    #$00                     ;A5DF: 81 00 
        BEQ     ZA5E8                    ;A5E1: 27 05 
        JSR     ZAB00                    ;A5E3: BD AB 00 
        BRA     ZA5F8                    ;A5E6: 20 10 
;------------------------------------------------------------------------
ZA5E8:	CLR     M80E1                    ;A5E8: 7F 80 E1 
        JSR     ZA847                    ;A5EB: BD A8 47 
        LDA     word_8006_X              ;A5EE: B6 80 06 
        CMPA    #$00                     ;A5F1: 81 00 
        BEQ     ZA5F8                    ;A5F3: 27 03 
        JSR     ZAB00                    ;A5F5: BD AB 00 
ZA5F8:	JSR     ROM_disablefd            ;A5F8: BD F4 D6 
        RTS                              ;A5FB: 39 
;------------------------------------------------------------------------
ZA5FC:	JSR     ROM_enablefd             ;A5FC: BD F4 C6 
        LDA     #$40                     ;A5FF: 86 40 
        ANDA    VIA_dr_b                 ;A601: B4 E2 00 
        CMPA    #$00                     ;A604: 81 00 
        BNE     ZA610                    ;A606: 26 08 
        LDA     #$07                     ;A608: 86 07 
        STA     word_8007_X              ;A60A: B7 80 07 
        LBRA    ZA64F                    ;A60D: 16 00 3F 
ZA610:	LDA     MIDI_program_number      ;A610: B6 80 CF 
        CMPA    #$08                     ;A613: 81 08 
        BNE     ZA61D                    ;A615: 26 06 
        LDY     #ROM_ts_shortseq         ;A617: 10 8E FB A8 
        BRA     ZA625                    ;A61B: 20 08 
;------------------------------------------------------------------------
ZA61D:	CMPA    #$0A                     ;A61D: 81 0A 
        BNE     ZA625                    ;A61F: 26 04 
        LDY     #ROM_ts_longseq          ;A621: 10 8E FB C8 
ZA625:	CLR     M80E3                    ;A625: 7F 80 E3 
        JSR     ZAAD2                    ;A628: BD AA D2 
        LDA     word_8006_X              ;A62B: B6 80 06 
        CMPA    #$00                     ;A62E: 81 00 
        BEQ     ZA638                    ;A630: 27 06 
        JSR     ZAB00                    ;A632: BD AB 00 
        LBRA    ZA64F                    ;A635: 16 00 17 
ZA638:	LDA     #$02                     ;A638: 86 02 
        STA     M80E1                    ;A63A: B7 80 E1 
        JSR     ZA847                    ;A63D: BD A8 47 
        LDA     word_8006_X              ;A640: B6 80 06 
        CMPA    #$00                     ;A643: 81 00 
        BEQ     ZA64C                    ;A645: 27 05 
        JSR     ZAB00                    ;A647: BD AB 00 
        BRA     ZA64F                    ;A64A: 20 03 
;------------------------------------------------------------------------
ZA64C:	JSR     ZA97C                    ;A64C: BD A9 7C 
ZA64F:	JSR     ROM_disablefd            ;A64F: BD F4 D6 
        RTS                              ;A652: 39 
;------------------------------------------------------------------------
ZA653:	JSR     ROM_enablefd             ;A653: BD F4 C6 
        LDA     #$40                     ;A656: 86 40 
        ANDA    VIA_dr_b                 ;A658: B4 E2 00 
        CMPA    #$00                     ;A65B: 81 00 
        BNE     ZA667                    ;A65D: 26 08 
        LDA     #$07                     ;A65F: 86 07 
        STA     word_8007_X              ;A661: B7 80 07 
        LBRA    ZA698                    ;A664: 16 00 31 
ZA667:	LDA     #$02                     ;A667: 86 02 
        STA     M80E3                    ;A669: B7 80 E3 
        LDY     #ROM_ts_sysparam         ;A66C: 10 8E FB 88 
        JSR     ZAAD2                    ;A670: BD AA D2 
        LDA     word_8006_X              ;A673: B6 80 06 
        CMPA    #$00                     ;A676: 81 00 
        BEQ     ZA67F                    ;A678: 27 05 
        JSR     ZAB00                    ;A67A: BD AB 00 
        BRA     ZA698                    ;A67D: 20 19 
;------------------------------------------------------------------------
ZA67F:	LDA     disk_first_sec           ;A67F: B6 80 D6 
        STA     M8003                    ;A682: B7 80 03 
        LDX     #word_8011_X             ;A685: 8E 80 11 
        STX     M8004                    ;A688: BF 80 04 
        JSR     ROM_writesector          ;A68B: BD F4 76 
        LDA     word_8006_X              ;A68E: B6 80 06 
        CMPA    #$00                     ;A691: 81 00 
        BEQ     ZA698                    ;A693: 27 03 
        JSR     ZAB00                    ;A695: BD AB 00 
ZA698:	JSR     ROM_disablefd            ;A698: BD F4 D6 
        RTS                              ;A69B: 39 
;------------------------------------------------------------------------
ZA69C:	LDY     #ROM_ts_lower            ;A69C: 10 8E FB 90 
        JSR     ZAAD2                    ;A6A0: BD AA D2 
        LDA     word_8006_X              ;A6A3: B6 80 06 
        CMPA    #$00                     ;A6A6: 81 00 
        BEQ     ZA6B0                    ;A6A8: 27 06 
        JSR     ZAB00                    ;A6AA: BD AB 00 
        LBRA    ZA6E7                    ;A6AD: 16 00 37 
ZA6B0:	CLR     M80DD                    ;A6B0: 7F 80 DD 
        LDA     #$02                     ;A6B3: 86 02 
        STA     M80DE                    ;A6B5: B7 80 DE 
        CLR     M80E0                    ;A6B8: 7F 80 E0 
        LDA     M80E1                    ;A6BB: B6 80 E1 
        CMPA    #$00                     ;A6BE: 81 00 
        BNE     ZA6C7                    ;A6C0: 26 05 
        JSR     ZA736                    ;A6C2: BD A7 36 
        BRA     ZA6CE                    ;A6C5: 20 07 
;------------------------------------------------------------------------
ZA6C7:	CMPA    #$02                     ;A6C7: 81 02 
        BNE     ZA6CE                    ;A6C9: 26 03 
        JSR     ZA78B                    ;A6CB: BD A7 8B 
ZA6CE:	LDA     word_8006_X              ;A6CE: B6 80 06 
        CMPA    #$00                     ;A6D1: 81 00 
        BEQ     ZA6DA                    ;A6D3: 27 05 
        JSR     ZAB00                    ;A6D5: BD AB 00 
        BRA     ZA6E7                    ;A6D8: 20 0D 
;------------------------------------------------------------------------
ZA6DA:	JSR     ZA7AE                    ;A6DA: BD A7 AE 
        LDA     word_8006_X              ;A6DD: B6 80 06 
        CMPA    #$00                     ;A6E0: 81 00 
        BEQ     ZA6E7                    ;A6E2: 27 03 
        JSR     ZAB00                    ;A6E4: BD AB 00 
ZA6E7:	RTS                              ;A6E7: 39 
;------------------------------------------------------------------------
ZA6E8:	LDY     #ROM_ts_upper            ;A6E8: 10 8E FB 9C 
        JSR     ZAAD2                    ;A6EC: BD AA D2 
        LDA     word_8006_X              ;A6EF: B6 80 06 
        CMPA    #$00                     ;A6F2: 81 00 
        BEQ     ZA6FC                    ;A6F4: 27 06 
        JSR     ZAB00                    ;A6F6: BD AB 00 
        LBRA    ZA735                    ;A6F9: 16 00 39 
ZA6FC:	LDA     #$02                     ;A6FC: 86 02 
        STA     M80DD                    ;A6FE: B7 80 DD 
        STA     M80E0                    ;A701: B7 80 E0 
        LDA     #$04                     ;A704: 86 04 
        STA     M80DE                    ;A706: B7 80 DE 
        LDA     M80E1                    ;A709: B6 80 E1 
        CMPA    #$00                     ;A70C: 81 00 
        BNE     ZA715                    ;A70E: 26 05 
        JSR     ZA736                    ;A710: BD A7 36 
        BRA     ZA71C                    ;A713: 20 07 
;------------------------------------------------------------------------
ZA715:	CMPA    #$02                     ;A715: 81 02 
        BNE     ZA71C                    ;A717: 26 03 
        JSR     ZA78B                    ;A719: BD A7 8B 
ZA71C:	LDA     word_8006_X              ;A71C: B6 80 06 
        CMPA    #$00                     ;A71F: 81 00 
        BEQ     ZA728                    ;A721: 27 05 
        JSR     ZAB00                    ;A723: BD AB 00 
        BRA     ZA735                    ;A726: 20 0D 
;------------------------------------------------------------------------
ZA728:	JSR     ZA7AE                    ;A728: BD A7 AE 
        LDA     word_8006_X              ;A72B: B6 80 06 
        CMPA    #$00                     ;A72E: 81 00 
        BEQ     ZA735                    ;A730: 27 03 
        JSR     ZAB00                    ;A732: BD AB 00 
ZA735:	RTS                              ;A735: 39 
;------------------------------------------------------------------------
ZA736:	LDA     disk_first_sec           ;A736: B6 80 D6 
        STA     M8003                    ;A739: B7 80 03 
        LDA     VIA_dr_b                 ;A73C: B6 E2 00 
        ORA     M80DD                    ;A73F: BA 80 DD 
        STA     VIA_dr_b                 ;A742: B7 E2 00 
        LDX     #M0000                   ;A745: 8E 00 00 
        STX     M8004                    ;A748: BF 80 04 
        JSR     ROM_readsector           ;A74B: BD F4 48 
        LDA     word_8006_X              ;A74E: B6 80 06 
        CMPA    #$00                     ;A751: 81 00 
        BEQ     ZA758                    ;A753: 27 03 
        LBRA    ZA78A                    ;A755: 16 00 32 
ZA758:	LDA     M80E0                    ;A758: B6 80 E0 
        CMPA    #$00                     ;A75B: 81 00 
        BNE     ZA76A                    ;A75D: 26 0B 
        LDX     #data_b31d_via_X         ;A75F: 8E B3 1D 
        LDD     #M0271                   ;A762: CC 02 71 
        ADDD    #data_b31d_via_X         ;A765: C3 B3 1D 
        BRA     ZA777                    ;A768: 20 0D 
;------------------------------------------------------------------------
ZA76A:	CMPA    #$02                     ;A76A: 81 02 
        BNE     ZA777                    ;A76C: 26 09 
        LDX     #data_b58e_via_X         ;A76E: 8E B5 8E 
        LDD     #M0271                   ;A771: CC 02 71 
        ADDD    #data_b58e_via_X         ;A774: C3 B5 8E 
ZA777:	STD     M80DB                    ;A777: FD 80 DB 
        LDY     #M0000                   ;A77A: 10 8E 00 00 
ZA77E:	LDA     ,Y+                      ;A77E: A6 A0 
        STA     ,X+                      ;A780: A7 80 
        CMPX    M80DB                    ;A782: BC 80 DB 
        BNE     ZA77E                    ;A785: 26 F7 
        INC     disk_first_sec           ;A787: 7C 80 D6 
ZA78A:	RTS                              ;A78A: 39 
;------------------------------------------------------------------------
ZA78B:	LDA     disk_first_sec           ;A78B: B6 80 D6 
        STA     M8003                    ;A78E: B7 80 03 
        LDA     M80E0                    ;A791: B6 80 E0 
        CMPA    #$00                     ;A794: 81 00 
        BNE     ZA79D                    ;A796: 26 05 
        LDX     #data_b31d_via_X         ;A798: 8E B3 1D 
        BRA     ZA7A4                    ;A79B: 20 07 
;------------------------------------------------------------------------
ZA79D:	CMPA    #$02                     ;A79D: 81 02 
        BNE     ZA7A4                    ;A79F: 26 03 
        LDX     #data_b58e_via_X         ;A7A1: 8E B5 8E 
ZA7A4:	STX     M8004                    ;A7A4: BF 80 04 
        JSR     ROM_writesector          ;A7A7: BD F4 76 
        INC     disk_first_sec           ;A7AA: 7C 80 D6 
        RTS                              ;A7AD: 39 
;------------------------------------------------------------------------
ZA7AE:	LDA     disk_first_sec           ;A7AE: B6 80 D6 
        STA     M8003                    ;A7B1: B7 80 03 
        LDA     disk_first_trk           ;A7B4: B6 80 D5 
        STA     M8002                    ;A7B7: B7 80 02 
ZA7BA:	LDA     VIA_dr_b                 ;A7BA: B6 E2 00 
        ORA     M80DD                    ;A7BD: BA 80 DD 
        STA     VIA_dr_b                 ;A7C0: B7 E2 00 
        LDX     #M0000                   ;A7C3: 8E 00 00 
ZA7C6:	STX     M8004                    ;A7C6: BF 80 04 
        LDA     M80E1                    ;A7C9: B6 80 E1 
        CMPA    #$00                     ;A7CC: 81 00 
        BNE     ZA7D5                    ;A7CE: 26 05 
        JSR     ROM_readsector           ;A7D0: BD F4 48 
        BRA     ZA7DC                    ;A7D3: 20 07 
;------------------------------------------------------------------------
ZA7D5:	CMPA    #$02                     ;A7D5: 81 02 
        BNE     ZA7DC                    ;A7D7: 26 03 
        JSR     ROM_writesector          ;A7D9: BD F4 76 
ZA7DC:	LDA     word_8006_X              ;A7DC: B6 80 06 
        CMPA    #$00                     ;A7DF: 81 00 
        BEQ     ZA7E5                    ;A7E1: 27 02 
        BRA     ZA846                    ;A7E3: 20 61 
;------------------------------------------------------------------------
ZA7E5:	INC     M8003                    ;A7E5: 7C 80 03 
        LDA     M8003                    ;A7E8: B6 80 03 
        CMPA    #$05                     ;A7EB: 81 05 
        BEQ     ZA7F4                    ;A7ED: 27 05 
        CMPX    #M8000                   ;A7EF: 8C 80 00 
        BNE     ZA7C6                    ;A7F2: 26 D2 
ZA7F4:	LDA     M8003                    ;A7F4: B6 80 03 
        CMPA    #$05                     ;A7F7: 81 05 
        BNE     ZA815                    ;A7F9: 26 1A 
        CLR     M8003                    ;A7FB: 7F 80 03 
        INC     M8002                    ;A7FE: 7C 80 02 
        LDA     M8002                    ;A801: B6 80 02 
        CMPA    disk_last_trk            ;A804: B1 80 D7 
        BHI     ZA815                    ;A807: 22 0C 
        JSR     ROM_fdcseekin            ;A809: BD F0 7D 
        LDA     word_8006_X              ;A80C: B6 80 06 
        CMPA    #$00                     ;A80F: 81 00 
        BEQ     ZA815                    ;A811: 27 02 
        BRA     ZA846                    ;A813: 20 31 
;------------------------------------------------------------------------
ZA815:	LDA     M8002                    ;A815: B6 80 02 
        CMPA    disk_last_trk            ;A818: B1 80 D7 
        BHI     ZA822                    ;A81B: 22 05 
        CMPX    #M8000                   ;A81D: 8C 80 00 
        BNE     ZA7C6                    ;A820: 26 A4 
ZA822:	LDA     M8002                    ;A822: B6 80 02 
        CMPA    disk_last_trk            ;A825: B1 80 D7 
        BHI     ZA831                    ;A828: 22 07 
        CMPX    #M8000                   ;A82A: 8C 80 00 
        LBNE    ZA7C6                    ;A82D: 10 26 FF 95 
ZA831:	INC     M80DD                    ;A831: 7C 80 DD 
        LDA     M8002                    ;A834: B6 80 02 
        CMPA    disk_last_trk            ;A837: B1 80 D7 
        BHI     ZA846                    ;A83A: 22 0A 
        LDA     M80DD                    ;A83C: B6 80 DD 
        CMPA    M80DE                    ;A83F: B1 80 DE 
        LBNE    ZA7BA                    ;A842: 10 26 FF 74 
ZA846:	RTS                              ;A846: 39 
;------------------------------------------------------------------------
ZA847:	LDA     disk_first_sec           ;A847: B6 80 D6 
        STA     M8003                    ;A84A: B7 80 03 
        LDA     disk_first_trk           ;A84D: B6 80 D5 
        STA     M8002                    ;A850: B7 80 02 
        LDA     MIDI_program_number      ;A853: B6 80 CF 
        CMPA    #$07                     ;A856: 81 07 
        BEQ     ZA861                    ;A858: 27 07 
        LDA     MIDI_program_number      ;A85A: B6 80 CF 
        CMPA    #$08                     ;A85D: 81 08 
        BNE     ZA869                    ;A85F: 26 08 
ZA861:	LDD     #M0800                   ;A861: CC 08 00 
        ADDD    #MB800                   ;A864: C3 B8 00 
        BRA     ZA86F                    ;A867: 20 06 
;------------------------------------------------------------------------
ZA869:	LDD     #M2000                   ;A869: CC 20 00 
        ADDD    #MB800                   ;A86C: C3 B8 00 
ZA86F:	STD     M80DB                    ;A86F: FD 80 DB 
        LDX     #MB800                   ;A872: 8E B8 00 
ZA875:	STX     M8004                    ;A875: BF 80 04 
        LDA     M80E1                    ;A878: B6 80 E1 
        CMPA    #$00                     ;A87B: 81 00 
        BNE     ZA884                    ;A87D: 26 05 
        JSR     ROM_readsector           ;A87F: BD F4 48 
        BRA     ZA88B                    ;A882: 20 07 
;------------------------------------------------------------------------
ZA884:	CMPA    #$02                     ;A884: 81 02 
        BNE     ZA88B                    ;A886: 26 03 
        JSR     ROM_writesector          ;A888: BD F4 76 
ZA88B:	LDA     word_8006_X              ;A88B: B6 80 06 
        CMPA    #$00                     ;A88E: 81 00 
        BEQ     ZA894                    ;A890: 27 02 
        BRA     ZA8B8                    ;A892: 20 24 
;------------------------------------------------------------------------
ZA894:	INC     M8002                    ;A894: 7C 80 02 
        LDA     M8002                    ;A897: B6 80 02 
        CMPA    disk_last_trk            ;A89A: B1 80 D7 
        BHI     ZA8AB                    ;A89D: 22 0C 
        JSR     ROM_fdcseekin            ;A89F: BD F0 7D 
        LDA     word_8006_X              ;A8A2: B6 80 06 
        CMPA    #$00                     ;A8A5: 81 00 
        BEQ     ZA8AB                    ;A8A7: 27 02 
        BRA     ZA8B8                    ;A8A9: 20 0D 
;------------------------------------------------------------------------
ZA8AB:	LDA     M8002                    ;A8AB: B6 80 02 
        CMPA    disk_last_trk            ;A8AE: B1 80 D7 
        BHI     ZA8B8                    ;A8B1: 22 05 
        CMPX    M80DB                    ;A8B3: BC 80 DB 
        BNE     ZA875                    ;A8B6: 26 BD 
ZA8B8:	RTS                              ;A8B8: 39 
;------------------------------------------------------------------------
ZA8B9:	CLR     M80E2                    ;A8B9: 7F 80 E2 
        JSR     ZAA2F                    ;A8BC: BD AA 2F 
        LDA     word_8006_X              ;A8BF: B6 80 06 
        CMPA    #$00                     ;A8C2: 81 00 
        BEQ     ZA8CC                    ;A8C4: 27 06 
        JSR     ZAB00                    ;A8C6: BD AB 00 
        LBRA    ZA97B                    ;A8C9: 16 00 AF 
ZA8CC:	LDA     MIDI_program_number      ;A8CC: B6 80 CF 
        CMPA    #$03                     ;A8CF: 81 03 
        LBNE    ZA8ED                    ;A8D1: 10 26 00 18 
        LDB     M80D0                    ;A8D5: F6 80 D0 
        DECB                             ;A8D8: 5A 
        LDX     #ROM_unknown_fbdf        ;A8D9: 8E FB DF 
        LDA     B,X                      ;A8DC: A6 85 
        ANDA    vector_80d2_X            ;A8DE: B4 80 D2 
        CMPA    #$00                     ;A8E1: 81 00 
        BNE     ZA8EA                    ;A8E3: 26 05 
        LDB     #$04                     ;A8E5: C6 04 
        STB     word_8007_X              ;A8E7: F7 80 07 
ZA8EA:	LBRA    ZA97B                    ;A8EA: 16 00 8E 
ZA8ED:	CMPA    #$07                     ;A8ED: 81 07 
        LBNE    ZA94F                    ;A8EF: 10 26 00 5C 
        LDA     M80D0                    ;A8F3: B6 80 D0 
        CMPA    #$01                     ;A8F6: 81 01 
        BCS     ZA937                    ;A8F8: 25 3D 
        LDA     M80D0                    ;A8FA: B6 80 D0 
        CMPA    #$03                     ;A8FD: 81 03 
        BHI     ZA937                    ;A8FF: 22 36 
        LDX     #ROM_bitmask_0to2        ;A901: 8E FB EA 
        LDB     M80D0                    ;A904: F6 80 D0 
        DECB                             ;A907: 5A 
        LDA     B,X                      ;A908: A6 85 
        ANDA    M80D4                    ;A90A: B4 80 D4 
        CMPA    #$00                     ;A90D: 81 00 
        BNE     ZA924                    ;A90F: 26 13 
        LDX     #ROM_bitmask_0to7        ;A911: 8E FB E2 
        LDA     B,X                      ;A914: A6 85 
        ANDA    M80D3                    ;A916: B4 80 D3 
        CMPA    #$00                     ;A919: 81 00 
        BNE     ZA922                    ;A91B: 26 05 
        LDB     #$05                     ;A91D: C6 05 
        STB     word_8007_X              ;A91F: F7 80 07 
ZA922:	BRA     ZA935                    ;A922: 20 11 
;------------------------------------------------------------------------
ZA924:	LDA     M80E4                    ;A924: B6 80 E4 
        BEQ     ZA930                    ;A927: 27 07 
        LDA     #$09                     ;A929: 86 09 
        STA     MIDI_program_number      ;A92B: B7 80 CF 
        BRA     ZA935                    ;A92E: 20 05 
;------------------------------------------------------------------------
ZA930:	LDA     #$09                     ;A930: 86 09 
        STA     word_8007_X              ;A932: B7 80 07 
ZA935:	BRA     ZA94C                    ;A935: 20 15 
;------------------------------------------------------------------------
ZA937:	LDX     #ROM_bitmask_0to7        ;A937: 8E FB E2 
        LDB     M80D0                    ;A93A: F6 80 D0 
        DECB                             ;A93D: 5A 
        LDA     B,X                      ;A93E: A6 85 
        ANDA    M80D3                    ;A940: B4 80 D3 
        CMPA    #$00                     ;A943: 81 00 
        BNE     ZA94C                    ;A945: 26 05 
        LDB     #$05                     ;A947: C6 05 
        STB     word_8007_X              ;A949: F7 80 07 
ZA94C:	LBRA    ZA97B                    ;A94C: 16 00 2C 
ZA94F:	LDX     #ROM_unknown_fbd4        ;A94F: 8E FB D4 
        LDA     MIDI_program_number      ;A952: B6 80 CF 
        LDB     M80D0                    ;A955: F6 80 D0 
        INCB                             ;A958: 5C 
        INCB                             ;A959: 5C 
        MUL                              ;A95A: 3D 
        LDA     B,X                      ;A95B: A6 85 
        ANDA    vector_80d2_X            ;A95D: B4 80 D2 
        CMPA    #$00                     ;A960: 81 00 
        BNE     ZA97B                    ;A962: 26 17 
        LDA     MIDI_program_number      ;A964: B6 80 CF 
        CMPA    #$01                     ;A967: 81 01 
        BNE     ZA972                    ;A969: 26 07 
        LDB     #$03                     ;A96B: C6 03 
        STB     word_8007_X              ;A96D: F7 80 07 
        BRA     ZA97B                    ;A970: 20 09 
;------------------------------------------------------------------------
ZA972:	CMPA    #$02                     ;A972: 81 02 
        BNE     ZA97B                    ;A974: 26 05 
        LDB     #$02                     ;A976: C6 02 
        STB     word_8007_X              ;A978: F7 80 07 
ZA97B:	RTS                              ;A97B: 39 
;------------------------------------------------------------------------
ZA97C:	CLR     M80E2                    ;A97C: 7F 80 E2 
        JSR     ZAA2F                    ;A97F: BD AA 2F 
        LDA     word_8006_X              ;A982: B6 80 06 
        CMPA    #$00                     ;A985: 81 00 
        BEQ     ZA98F                    ;A987: 27 06 
        JSR     ZAB00                    ;A989: BD AB 00 
        LBRA    ZAA0A                    ;A98C: 16 00 7B 
ZA98F:	LDA     MIDI_program_number      ;A98F: B6 80 CF 
        CMPA    #$06                     ;A992: 81 06 
        LBNE    ZA9AA                    ;A994: 10 26 00 12 
        LDB     M80D0                    ;A998: F6 80 D0 
        DECB                             ;A99B: 5A 
        LDX     #ROM_unknown_fbdf        ;A99C: 8E FB DF 
        LDA     B,X                      ;A99F: A6 85 
        ORA     vector_80d2_X            ;A9A1: BA 80 D2 
        STA     vector_80d2_X            ;A9A4: B7 80 D2 
        LBRA    ZA9F8                    ;A9A7: 16 00 4E 
ZA9AA:	CMPA    #$08                     ;A9AA: 81 08 
        LBNE    ZA9C5                    ;A9AC: 10 26 00 15 
        LDX     #ROM_bitmask_0to7        ;A9B0: 8E FB E2 
        LDB     M80D0                    ;A9B3: F6 80 D0 
        DECB                             ;A9B6: 5A 
        LDA     B,X                      ;A9B7: A6 85 
        ORA     M80D3                    ;A9B9: BA 80 D3 
        STA     M80D3                    ;A9BC: B7 80 D3 
        JSR     ZAA0B                    ;A9BF: BD AA 0B 
        LBRA    ZA9F8                    ;A9C2: 16 00 33 
ZA9C5:	CMPA    #$0A                     ;A9C5: 81 0A 
        LBNE    ZA9E0                    ;A9C7: 10 26 00 15 
        LDX     #ROM_bitmask_0to2        ;A9CB: 8E FB EA 
        LDB     M80D0                    ;A9CE: F6 80 D0 
        DECB                             ;A9D1: 5A 
        LDA     B,X                      ;A9D2: A6 85 
        ORA     M80D4                    ;A9D4: BA 80 D4 
        STA     M80D4                    ;A9D7: B7 80 D4 
        JSR     ZAA0B                    ;A9DA: BD AA 0B 
        LBRA    ZA9F8                    ;A9DD: 16 00 18 
ZA9E0:	LDX     #ROM_unknown_fbd4        ;A9E0: 8E FB D4 
        LDA     MIDI_program_number      ;A9E3: B6 80 CF 
        ANDCC   #$FE                     ;A9E6: 1C FE 
        SBCA    #$03                     ;A9E8: 82 03 
        LDB     M80D0                    ;A9EA: F6 80 D0 
        INCB                             ;A9ED: 5C 
        INCB                             ;A9EE: 5C 
        MUL                              ;A9EF: 3D 
        LDA     B,X                      ;A9F0: A6 85 
        ORA     vector_80d2_X            ;A9F2: BA 80 D2 
        STA     vector_80d2_X            ;A9F5: B7 80 D2 
ZA9F8:	LDA     #$02                     ;A9F8: 86 02 
        STA     M80E2                    ;A9FA: B7 80 E2 
        JSR     ZAA2F                    ;A9FD: BD AA 2F 
        LDA     word_8006_X              ;AA00: B6 80 06 
        CMPA    #$00                     ;AA03: 81 00 
        BEQ     ZAA0A                    ;AA05: 27 03 
        JSR     ZAB00                    ;AA07: BD AB 00 
ZAA0A:	RTS                              ;AA0A: 39 
;------------------------------------------------------------------------
ZAA0B:	LDB     M80D0                    ;AA0B: F6 80 D0 
        DECB                             ;AA0E: 5A 
        LDA     MIDI_program_number      ;AA0F: B6 80 CF 
        CMPA    #$08                     ;AA12: 81 08 
        BNE     ZAA23                    ;AA14: 26 0D 
        LDX     #ROM_unknown_fbf0        ;AA16: 8E FB F0 
        LDA     B,X                      ;AA19: A6 85 
        ANDA    M80D4                    ;AA1B: B4 80 D4 
        STA     M80D4                    ;AA1E: B7 80 D4 
        BRA     ZAA2E                    ;AA21: 20 0B 
;------------------------------------------------------------------------
ZAA23:	LDX     #ROM_unknown_fbed        ;AA23: 8E FB ED 
        LDA     B,X                      ;AA26: A6 85 
        ANDA    M80D3                    ;AA28: B4 80 D3 
        STA     M80D3                    ;AA2B: B7 80 D3 
ZAA2E:	RTS                              ;AA2E: 39 
;------------------------------------------------------------------------
ZAA2F:	LDY     #ROM_ts_osflags          ;AA2F: 10 8E FB 8C 
        LDA     #$02                     ;AA33: 86 02 
        STA     M80E3                    ;AA35: B7 80 E3 
        JSR     ZAAD2                    ;AA38: BD AA D2 
        LDA     word_8006_X              ;AA3B: B6 80 06 
        CMPA    #$00                     ;AA3E: 81 00 
        BEQ     ZAA45                    ;AA40: 27 03 
        LBRA    ZAAD1                    ;AA42: 16 00 8C 
ZAA45:	LDA     disk_first_trk           ;AA45: B6 80 D5 
        STA     M8002                    ;AA48: B7 80 02 
        LDA     disk_first_sec           ;AA4B: B6 80 D6 
        STA     M8003                    ;AA4E: B7 80 03 
        LDX     #vector_80d2_X           ;AA51: 8E 80 D2 
        LDA     #$0A                     ;AA54: 86 0A 
        STA     M8001                    ;AA56: B7 80 01 
ZAA59:	LDA     M80E2                    ;AA59: B6 80 E2 
        CMPA    #$00                     ;AA5C: 81 00 
        BNE     ZAA6A                    ;AA5E: 26 0A 
        JSR     ROM_fdcskipsector        ;AA60: BD F0 13 
        LDA     FDC_data                 ;AA63: B6 E8 03 
        STA     ,X                       ;AA66: A7 84 
        BRA     ZAA71                    ;AA68: 20 07 
;------------------------------------------------------------------------
ZAA6A:	CMPA    #$02                     ;AA6A: 81 02 
        BNE     ZAA71                    ;AA6C: 26 03 
        JSR     ROM_fdcfillsector        ;AA6E: BD F0 37 
ZAA71:	DEC     M8001                    ;AA71: 7A 80 01 
        LDA     M8001                    ;AA74: B6 80 01 
        BEQ     ZAA80                    ;AA77: 27 07 
        LDA     word_8006_X              ;AA79: B6 80 06 
        CMPA    #$00                     ;AA7C: 81 00 
        BNE     ZAA59                    ;AA7E: 26 D9 
ZAA80:	LDA     word_8006_X              ;AA80: B6 80 06 
        CMPA    #$00                     ;AA83: 81 00 
        BEQ     ZAAA5                    ;AA85: 27 1E 
        JSR     ROM_fdcseekout           ;AA87: BD F0 86 
        JSR     ROM_fdcseekin            ;AA8A: BD F0 7D 
        LDA     M80E2                    ;AA8D: B6 80 E2 
        CMPA    #$00                     ;AA90: 81 00 
        BNE     ZAA9E                    ;AA92: 26 0A 
        JSR     ROM_fdcskipsector        ;AA94: BD F0 13 
        LDA     FDC_data                 ;AA97: B6 E8 03 
        STA     ,X                       ;AA9A: A7 84 
        BRA     ZAAA5                    ;AA9C: 20 07 
;------------------------------------------------------------------------
ZAA9E:	CMPA    #$02                     ;AA9E: 81 02 
        BNE     ZAAA5                    ;AAA0: 26 03 
        JSR     ROM_fdcfillsector        ;AAA2: BD F0 37 
ZAAA5:	LDA     word_8006_X              ;AAA5: B6 80 06 
        CMPA    #$00                     ;AAA8: 81 00 
        BEQ     ZAAAE                    ;AAAA: 27 02 
        BRA     ZAAD1                    ;AAAC: 20 23 
;------------------------------------------------------------------------
ZAAAE:	LEAX    $01,X                    ;AAAE: 30 01 
        INC     M8002                    ;AAB0: 7C 80 02 
        LDA     M8002                    ;AAB3: B6 80 02 
        CMPA    disk_last_trk            ;AAB6: B1 80 D7 
        BHI     ZAAC7                    ;AAB9: 22 0C 
        JSR     ROM_gototrack2           ;AABB: BD F4 A4 
        LDA     word_8006_X              ;AABE: B6 80 06 
        CMPA    #$00                     ;AAC1: 81 00 
        BEQ     ZAAC7                    ;AAC3: 27 02 
        BRA     ZAAD1                    ;AAC5: 20 0A 
;------------------------------------------------------------------------
ZAAC7:	LDA     M8002                    ;AAC7: B6 80 02 
        CMPA    disk_last_trk            ;AACA: B1 80 D7 
        LBLS    ZAA59                    ;AACD: 10 23 FF 88 
ZAAD1:	RTS                              ;AAD1: 39 
;------------------------------------------------------------------------
ZAAD2:	LDA     M80E3                    ;AAD2: B6 80 E3 
        CMPA    #$00                     ;AAD5: 81 00 
        BNE     ZAADE                    ;AAD7: 26 05 
        LDA     M80D1                    ;AAD9: B6 80 D1 
        BRA     ZAAE3                    ;AADC: 20 05 
;------------------------------------------------------------------------
ZAADE:	CMPA    #$02                     ;AADE: 81 02 
        BNE     ZAAE3                    ;AAE0: 26 01 
        CLRA                             ;AAE2: 4F 
ZAAE3:	LEAX    A,Y                      ;AAE3: 30 A6 
        LDA     ,X+                      ;AAE5: A6 80 
        STA     disk_first_trk           ;AAE7: B7 80 D5 
        STA     M8002                    ;AAEA: B7 80 02 
        LDA     ,X+                      ;AAED: A6 80 
        STA     disk_first_sec           ;AAEF: B7 80 D6 
        LDA     ,X+                      ;AAF2: A6 80 
        STA     disk_last_trk            ;AAF4: B7 80 D7 
        LDA     ,X                       ;AAF7: A6 84 
        STA     disk_last_sec            ;AAF9: B7 80 D8 
        JSR     ROM_gototrack2           ;AAFC: BD F4 A4 
        RTS                              ;AAFF: 39 
;------------------------------------------------------------------------
ZAB00:	LDA     #$01                     ;AB00: 86 01 
        STA     word_8007_X              ;AB02: B7 80 07 
        LDA     #$10                     ;AB05: 86 10 
        BITA    word_8006_X              ;AB07: B5 80 06 
        BEQ     ZAB13                    ;AB0A: 27 07 
        LDA     #$06                     ;AB0C: 86 06 
        STA     word_8007_X              ;AB0E: B7 80 07 
        BRA     ZAB1F                    ;AB11: 20 0C 
;------------------------------------------------------------------------
ZAB13:	LDA     #$40                     ;AB13: 86 40 
        BITA    word_8006_X              ;AB15: B5 80 06 
        BEQ     ZAB1F                    ;AB18: 27 05 
        LDA     #$08                     ;AB1A: 86 08 
        STA     word_8007_X              ;AB1C: B7 80 07 
ZAB1F:	RTS                              ;AB1F: 39 
;------------------------------------------------------------------------
ZAB20:	STB     M80D0                    ;AB20: F7 80 D0 
        DECB                             ;AB23: 5A 
        ASLB                             ;AB24: 58 
        ASLB                             ;AB25: 58 
        STB     M80D1                    ;AB26: F7 80 D1 
        RTS                              ;AB29: 39 
;------------------------------------------------------------------------

word_via_80ee:
        FDB     data_via_ab2a            ;AB2A: B7 A2 
;------------------------------------------------------------------------
ZAB2C:	LDU     vec_b804                 ;AB2C: FE B8 04 
        LDA     ,U+                      ;AB2F: A6 C0 
        STU     M80EC                    ;AB31: DF EC 
        STA     M80F1                    ;AB33: 97 F1 
        RTS                              ;AB35: 39 
;------------------------------------------------------------------------
ZAB36:	LDU     vec_b808                 ;AB36: FE B8 08 
        STU     vec_b804                 ;AB39: FF B8 04 
        STA     ,U+                      ;AB3C: A7 C0 
        STU     M80EE                    ;AB3E: DF EE 
        CLR     M80F0                    ;AB40: 0F F0 
        RTS                              ;AB42: 39 
;------------------------------------------------------------------------
ZAB43:	BSR     ZAB2C                    ;AB43: 8D E7 
ZAB45:	CLR     M8036                    ;AB45: 0F 36 
        CLR     M80E9                    ;AB47: 0F E9 
        LDB     #$02                     ;AB49: C6 02 
        STB     M80E7                    ;AB4B: D7 E7 
        RTS                              ;AB4D: 39 
;------------------------------------------------------------------------
ZAB4E:	LDA     #$04                     ;AB4E: 86 04 
        STA     M80E7                    ;AB50: 97 E7 
        RTS                              ;AB52: 39 
;------------------------------------------------------------------------
ZAB53:	LDU     M80E5                    ;AB53: DE E5 
        LEAU    -$03,U                   ;AB55: 33 5D 
        STU     M80EC                    ;AB57: DF EC 
        BSR     ZAB36                    ;AB59: 8D DB 
        LDB     #$06                     ;AB5B: C6 06 
        STB     M80E7                    ;AB5D: D7 E7 
        RTS                              ;AB5F: 39 
;------------------------------------------------------------------------
ZAB60:	CLR     M8036                    ;AB60: 0F 36 
        CLR     M80E9                    ;AB62: 0F E9 
        INC     M80EB                    ;AB64: 0C EB 
        CLR     M80EA                    ;AB66: 0F EA 
        LDA     #$60                     ;AB68: 86 60 
        STA     word_8026_X              ;AB6A: 97 26 
        LDA     #$08                     ;AB6C: 86 08 
        STA     M80E7                    ;AB6E: 97 E7 
        LDB     adc_pitchwheel_last      ;AB70: F6 90 09 
        JSR     ZADAF                    ;AB73: BD AD AF 
        LDB     val_modwheel_related     ;AB76: D6 6C 
        JSR     ZADB2                    ;AB78: BD AD B2 
        LDB     kbd_flag_damper_pedal_onoff ;AB7B: D6 6B 
        JMP     pedal_handler_2          ;AB7D: 7E AD B6 
;------------------------------------------------------------------------
ZAB80:	CLR     M8036                    ;AB80: 0F 36 
        CLR     M80E9                    ;AB82: 0F E9 
ZAB84:	JSR     ZAC10                    ;AB84: BD AC 10 
        BSR     ZAB2C                    ;AB87: 8D A3 
        BSR     ZAB36                    ;AB89: 8D AB 
        LDB     #$0A                     ;AB8B: C6 0A 
        STB     M80E7                    ;AB8D: D7 E7 
        RTS                              ;AB8F: 39 
;------------------------------------------------------------------------
ZAB90:	LDA     M80E7                    ;AB90: 96 E7 
        BEQ     ZAC0F                    ;AB92: 27 7B 
        CLR     M80E7                    ;AB94: 0F E7 
        LDU     M80EE                    ;AB96: DE EE 
        CMPA    #$06                     ;AB98: 81 06 
        BNE     ZABA2                    ;AB9A: 26 06 
ZAB9C:	LDA     #$FF                     ;AB9C: 86 FF 
        BRA     ZABD2                    ;AB9E: 20 32 
;------------------------------------------------------------------------
        BRA     ZABEB                    ;ABA0: 20 49 
;------------------------------------------------------------------------
ZABA2:	CMPA    #$08                     ;ABA2: 81 08 
        BNE     ZABE4                    ;ABA4: 26 3E 
        LDA     M80F0                    ;ABA6: 96 F0 
        TST     word_8024_X              ;ABA8: 0D 24 
        BEQ     ZABD2                    ;ABAA: 27 26 
        TST     M80EB                    ;ABAC: 0D EB 
        BNE     ZAB9C                    ;ABAE: 26 EC 
        LDB     M80EA                    ;ABB0: D6 EA 
        CMPB    #$0C                     ;ABB2: C1 0C 
        BCC     ZABBE                    ;ABB4: 24 08 
        SUBA    M80EA                    ;ABB6: 90 EA 
        BCC     ZABBC                    ;ABB8: 24 02 
        ADDA    #$18                     ;ABBA: 8B 18 
ZABBC:	BRA     ZABD2                    ;ABBC: 20 14 
;------------------------------------------------------------------------
ZABBE:	NEGB                             ;ABBE: 50 
        ADDB    #$18                     ;ABBF: CB 18 
        PSHS    B                        ;ABC1: 34 04 
        ADDA    ,S+                      ;ABC3: AB E0 
        BCC     ZABD2                    ;ABC5: 24 0B 
        INCA                             ;ABC7: 4C 
        STA     -$01,U                   ;ABC8: A7 5F 
        LDA     #$81                     ;ABCA: 86 81 
        STA     ,U+                      ;ABCC: A7 C0 
        LDA     #$FF                     ;ABCE: 86 FF 
        STA     ,U+                      ;ABD0: A7 C0 
ZABD2:	STA     -$01,U                   ;ABD2: A7 5F 
        LDA     #$80                     ;ABD4: 86 80 
        STA     ,U+                      ;ABD6: A7 C0 
        STA     ,U+                      ;ABD8: A7 C0 
        STA     ,U+                      ;ABDA: A7 C0 
        STU     vec_sysmsg               ;ABDC: FF B8 06 
        JSR     ZAB2C                    ;ABDF: BD AB 2C 
        BRA     ZABEB                    ;ABE2: 20 07 
;------------------------------------------------------------------------
ZABE4:	CMPA    #$0A                     ;ABE4: 81 0A 
        BNE     ZABEB                    ;ABE6: 26 03 
        JSR     ZAC27                    ;ABE8: BD AC 27 
ZABEB:	LDU     #word_via_80ee           ;ABEB: CE AB 2A 
        STU     M80EE                    ;ABEE: DF EE 
        BSR     ZAC3F                    ;ABF0: 8D 4D 
ZABF2:	LDX     #vector_806f_X           ;ABF2: 8E 80 6F 
        JSR     Z87E2                    ;ABF5: BD 87 E2 
        LDU     #Z8E4D                   ;ABF8: CE 8E 4D 
        LDA     #$24                     ;ABFB: 86 24 
ZABFD:	LDB     A,U                      ;ABFD: E6 C6 
        BPL     ZAC0A                    ;ABFF: 2A 09 
        ANDB    #$7F                     ;AC01: C4 7F 
        STB     A,U                      ;AC03: E7 C6 
        LDB     #$40                     ;AC05: C6 40 
        JSR     ZA0C3                    ;AC07: BD A0 C3 
ZAC0A:	INCA                             ;AC0A: 4C 
        CMPA    #$61                     ;AC0B: 81 61 
        BCS     ZABFD                    ;AC0D: 25 EE 
ZAC0F:	RTS                              ;AC0F: 39 
;------------------------------------------------------------------------
ZAC10:	LDX     vec_sysmsg               ;AC10: BE B8 06 
        LDU     M80E5                    ;AC13: DE E5 
        STU     vec_sysmsg               ;AC15: FF B8 06 
ZAC18:	CMPX    vec_b804                 ;AC18: BC B8 04 
        BLS     ZAC23                    ;AC1B: 23 06 
        LDA     ,-X                      ;AC1D: A6 82 
        STA     ,-U                      ;AC1F: A7 C2 
        BRA     ZAC18                    ;AC21: 20 F5 
;------------------------------------------------------------------------
ZAC23:	STU     vec_b804                 ;AC23: FF B8 04 
        RTS                              ;AC26: 39 
;------------------------------------------------------------------------
ZAC27:	LDX     M80EC                    ;AC27: 9E EC 
        LDU     M80EE                    ;AC29: DE EE 
        STU     M80EC                    ;AC2B: DF EC 
        LDA     M80F0                    ;AC2D: 96 F0 
        ADDA    M80F1                    ;AC2F: 9B F1 
        STA     -$01,U                   ;AC31: A7 5F 
ZAC33:	LDA     ,X+                      ;AC33: A6 80 
        STA     ,U+                      ;AC35: A7 C0 
        CMPX    M80E5                    ;AC37: 9C E5 
        BCS     ZAC33                    ;AC39: 25 F8 
        STU     vec_sysmsg               ;AC3B: FF B8 06 
        RTS                              ;AC3E: 39 
;------------------------------------------------------------------------
ZAC3F:	CLRB                             ;AC3F: 5F 
ZAC40:	STB     M8072                    ;AC40: D7 72 
        JSR     MIDI_set_pedal_to_B      ;AC42: BD A0 DA 
        TSTB                             ;AC45: 5D 
        BNE     ZAC4E                    ;AC46: 26 06 
        LDX     #vector_806f_X           ;AC48: 8E 80 6F 
        JSR     Z87DD                    ;AC4B: BD 87 DD 
ZAC4E:	RTS                              ;AC4E: 39 
;------------------------------------------------------------------------

task3_code_D:
        LDD     #MD800                   ;AC4F: CC D8 00 
        STD     MC000                    ;AC52: FD C0 00 
        CMPD    MC000                    ;AC55: 10 B3 C0 00 
        BNE     ZAC5F                    ;AC59: 26 04 
        STA     M80E4                    ;AC5B: 97 E4 
        STD     M80E5                    ;AC5D: DD E5 
ZAC5F:	LDA     M80E7                    ;AC5F: 96 E7 
        BEQ     ZAC9E                    ;AC61: 27 3B 
        LDB     word_8024_X              ;AC63: D6 24 
        BNE     ZAC87                    ;AC65: 26 20 
        CMPA    #$04                     ;AC67: 81 04 
        BEQ     ZAC85                    ;AC69: 27 1A 
        CMPA    #$06                     ;AC6B: 81 06 
        BEQ     ZAC85                    ;AC6D: 27 16 
        TST     M8036                    ;AC6F: 0D 36 
ZAC71:	BEQ     ZAC85                    ;AC71: 27 12 
        LDB     M80E8                    ;AC73: D6 E8 
        ADDB    word_8026_X              ;AC75: DB 26 
        STB     M80E8                    ;AC77: D7 E8 
        BCC     ZAC81                    ;AC79: 24 06 
        JSR     ZACA3                    ;AC7B: BD AC A3 
        JSR     MIDI_do_timing_clock     ;AC7E: BD A1 16 
ZAC81:	DEC     M8036                    ;AC81: 0A 36 
        BRA     ZAC71                    ;AC83: 20 EC 
;------------------------------------------------------------------------
ZAC85:	BRA     ZAC9E                    ;AC85: 20 17 
;------------------------------------------------------------------------
ZAC87:	TST     M80E9                    ;AC87: 0D E9 
ZAC89:	BEQ     ZAC9E                    ;AC89: 27 13 
        JSR     ZACA3                    ;AC8B: BD AC A3 
        LDA     M80EA                    ;AC8E: 96 EA 
        INCA                             ;AC90: 4C 
        CMPA    #$18                     ;AC91: 81 18 
        BNE     ZAC98                    ;AC93: 26 03 
        CLRA                             ;AC95: 4F 
        CLR     M80EB                    ;AC96: 0F EB 
ZAC98:	STA     M80EA                    ;AC98: 97 EA 
        DEC     M80E9                    ;AC9A: 0A E9 
        BRA     ZAC89                    ;AC9C: 20 EB 
;------------------------------------------------------------------------
ZAC9E:	JSR     context_switch           ;AC9E: BD 88 5E 
        BRA     ZAC5F                    ;ACA1: 20 BC 
;------------------------------------------------------------------------
ZACA3:	LDA     M80E7                    ;ACA3: 96 E7 
        CMPA    #$02                     ;ACA5: 81 02 
        BNE     ZACB6                    ;ACA7: 26 0D 
        TST     M80F1                    ;ACA9: 0D F1 
ZACAB:	BNE     ZACB4                    ;ACAB: 26 07 
        JSR     ZACEB                    ;ACAD: BD AC EB 
        TST     M80F1                    ;ACB0: 0D F1 
        BRA     ZACAB                    ;ACB2: 20 F7 
;------------------------------------------------------------------------
ZACB4:	BRA     ZACE2                    ;ACB4: 20 2C 
;------------------------------------------------------------------------
ZACB6:	CMPA    #$0A                     ;ACB6: 81 0A 
        BNE     ZACD0                    ;ACB8: 26 16 
        LDA     M80F1                    ;ACBA: 96 F1 
ZACBC:	BNE     ZACCE                    ;ACBC: 26 10 
        JSR     ZACEB                    ;ACBE: BD AC EB 
        LDD     M80F2                    ;ACC1: DC F2 
        CMPA    #$80                     ;ACC3: 81 80 
        BEQ     ZACCA                    ;ACC5: 27 03 
        JSR     ZAD8F                    ;ACC7: BD AD 8F 
ZACCA:	LDA     M80F1                    ;ACCA: 96 F1 
        BRA     ZACBC                    ;ACCC: 20 EE 
;------------------------------------------------------------------------
ZACCE:	BRA     ZACE2                    ;ACCE: 20 12 
;------------------------------------------------------------------------
ZACD0:	CMPA    #$08                     ;ACD0: 81 08 
        BNE     ZACE1                    ;ACD2: 26 0D 
        LDA     M80F0                    ;ACD4: 96 F0 
        CMPA    #$FF                     ;ACD6: 81 FF 
        BNE     ZACDF                    ;ACD8: 26 05 
        LDA     #$81                     ;ACDA: 86 81 
        JSR     ZAD9A                    ;ACDC: BD AD 9A 
ZACDF:	BRA     ZACE2                    ;ACDF: 20 01 
;------------------------------------------------------------------------
ZACE1:	RTS                              ;ACE1: 39 
;------------------------------------------------------------------------
ZACE2:	ORCC    #$50                     ;ACE2: 1A 50 
        DEC     M80F1                    ;ACE4: 0A F1 
        INC     M80F0                    ;ACE6: 0C F0 
        ANDCC   #$AF                     ;ACE8: 1C AF 
        RTS                              ;ACEA: 39 
;------------------------------------------------------------------------
ZACEB:	LDU     M80EC                    ;ACEB: DE EC 
        LDA     $02,U                    ;ACED: A6 42 
        STA     M80F1                    ;ACEF: 97 F1 
        LDD     ,U                       ;ACF1: EC C4 
        LEAU    $03,U                    ;ACF3: 33 43 
        STU     M80EC                    ;ACF5: DF EC 
        STD     M80F2                    ;ACF7: DD F2 
        BPL     ZAD51                    ;ACF9: 2A 56 
        ANDA    #$7F                     ;ACFB: 84 7F 
        CMPA    #$02                     ;ACFD: 81 02 
        BLE     ZAD18                    ;ACFF: 2F 17 
        JSR     ZA0B7                    ;AD01: BD A0 B7 
        LDY     #Z8E4D                   ;AD04: 10 8E 8E 4D 
        LDB     A,Y                      ;AD08: E6 A6 
        ORB     #$80                     ;AD0A: CA 80 
        STB     A,Y                      ;AD0C: E7 A6 
        LDB     M80F3                    ;AD0E: D6 F3 
        LDX     #vector_806f_X           ;AD10: 8E 80 6F 
        JSR     Z87C4                    ;AD13: BD 87 C4 
        BRA     ZAD4F                    ;AD16: 20 37 
;------------------------------------------------------------------------
ZAD18:	TSTA                             ;AD18: 4D 
        BEQ     ZAD23                    ;AD19: 27 08 
        STB     M80F1                    ;AD1B: D7 F1 
        LEAU    -$01,U                   ;AD1D: 33 5F 
        STU     M80EC                    ;AD1F: DF EC 
        BRA     ZAD4F                    ;AD21: 20 2C 
;------------------------------------------------------------------------
ZAD23:	LDA     word_8027_X              ;AD23: 96 27 
        BEQ     ZAD43                    ;AD25: 27 1C 
        CLR     M80F1                    ;AD27: 0F F1 
        LDA     M80E7                    ;AD29: 96 E7 
        CMPA    #$0A                     ;AD2B: 81 0A 
        BNE     ZAD3B                    ;AD2D: 26 0C 
        LEAU    -$03,U                   ;AD2F: 33 5D 
        STU     M80EC                    ;AD31: DF EC 
        JSR     ZAB90                    ;AD33: BD AB 90 
        JSR     ZAB84                    ;AD36: BD AB 84 
        BRA     ZAD41                    ;AD39: 20 06 
;------------------------------------------------------------------------
ZAD3B:	JSR     ZABF2                    ;AD3B: BD AB F2 
        JSR     ZAB2C                    ;AD3E: BD AB 2C 
ZAD41:	BRA     ZAD4F                    ;AD41: 20 0C 
;------------------------------------------------------------------------
ZAD43:	LEAU    -$03,U                   ;AD43: 33 5D 
        STU     M80EC                    ;AD45: DF EC 
        JSR     ZAB90                    ;AD47: BD AB 90 
        LDA     #$1A                     ;AD4A: 86 1A 
        JSR     pedal_handler_if_8028_not_zero ;AD4C: BD A4 04 
ZAD4F:	BRA     ZAD8E                    ;AD4F: 20 3D 
;------------------------------------------------------------------------
ZAD51:	CMPA    #$03                     ;AD51: 81 03 
        BLS     ZAD6C                    ;AD53: 23 17 
        JSR     MIDI_do_note_off         ;AD55: BD A0 C5 
        LDY     #Z8E4D                   ;AD58: 10 8E 8E 4D 
        LDB     A,Y                      ;AD5C: E6 A6 
        ANDB    #$7F                     ;AD5E: C4 7F 
        STB     A,Y                      ;AD60: E7 A6 
        LDB     M80F3                    ;AD62: D6 F3 
        LDX     #vector_806f_X           ;AD64: 8E 80 6F 
        JSR     Z87BF                    ;AD67: BD 87 BF 
        BRA     ZAD8E                    ;AD6A: 20 22 
;------------------------------------------------------------------------
ZAD6C:	CMPA    #$00                     ;AD6C: 81 00 
        BNE     ZAD7A                    ;AD6E: 26 0A 
        JSR     MIDI_set_pwheel_to_B     ;AD70: BD A0 CF 
        JSR     Z90C0                    ;AD73: BD 90 C0 
        STD     M8070                    ;AD76: DD 70 
        BRA     ZAD8E                    ;AD78: 20 14 
;------------------------------------------------------------------------
ZAD7A:	CMPA    #$01                     ;AD7A: 81 01 
        BNE     ZAD87                    ;AD7C: 26 09 
        STB     M8073                    ;AD7E: D7 73 
        STB     vector_806f_X            ;AD80: D7 6F 
        JSR     MIDI_set_mwheel_to_B     ;AD82: BD A0 E2 
        BRA     ZAD8E                    ;AD85: 20 07 
;------------------------------------------------------------------------
ZAD87:	CMPA    #$03                     ;AD87: 81 03 
        BNE     ZAD8E                    ;AD89: 26 03 
        JSR     ZAC40                    ;AD8B: BD AC 40 
ZAD8E:	RTS                              ;AD8E: 39 
;------------------------------------------------------------------------
ZAD8F:	CMPA    #$81                     ;AD8F: 81 81 
        BNE     ZADAD                    ;AD91: 26 1A 
        LDB     M80F0                    ;AD93: D6 F0 
        ADDB    M80F1                    ;AD95: DB F1 
        BCS     ZAD9A                    ;AD97: 25 01 
        RTS                              ;AD99: 39 
;------------------------------------------------------------------------
ZAD9A:	LDU     M80EE                    ;AD9A: DE EE 
        CMPU    M80EC                    ;AD9C: 11 93 EC 
        BCS     ZADA2                    ;AD9F: 25 01 
        RTS                              ;ADA1: 39 
;------------------------------------------------------------------------
ZADA2:	STA     ,U++                     ;ADA2: A7 C1 
        STU     M80EE                    ;ADA4: DF EE 
        LDB     M80F0                    ;ADA6: D6 F0 
        STB     -$03,U                   ;ADA8: E7 5D 
        CLR     M80F0                    ;ADAA: 0F F0 
        RTS                              ;ADAC: 39 
;------------------------------------------------------------------------
ZADAD:	BRA     ZADBC                    ;ADAD: 20 0D 
;------------------------------------------------------------------------
ZADAF:	CLRA                             ;ADAF: 4F 
        BRA     ZADBC                    ;ADB0: 20 0A 
;------------------------------------------------------------------------
ZADB2:	LDA     #$01                     ;ADB2: 86 01 
        BRA     ZADBC                    ;ADB4: 20 06 
;------------------------------------------------------------------------

pedal_handler_2:
        LDA     #$03                     ;ADB6: 86 03 
        BRA     ZADBC                    ;ADB8: 20 02 
;------------------------------------------------------------------------

adba_note_on_jsr:
        ORA     #$80                     ;ADBA: 8A 80 
ZADBC:	PSHS    CC                       ;ADBC: 34 01 
        ORCC    #$50                     ;ADBE: 1A 50 
        LDU     M80EE                    ;ADC0: DE EE 
        CMPU    M80EC                    ;ADC2: 11 93 EC 
        BCS     ZADD5                    ;ADC5: 25 0E 
        PULS    CC                       ;ADC7: 35 01 
        PSHS    B                        ;ADC9: 34 04 
        JSR     ZAB90                    ;ADCB: BD AB 90 
        LDA     #$1A                     ;ADCE: 86 1A 
        JSR     pedal_handler_if_8028_not_zero ;ADD0: BD A4 04 
        PULS    PC,B                     ;ADD3: 35 84 
;------------------------------------------------------------------------
ZADD5:	STD     ,U                       ;ADD5: ED C4 
        LDA     M80E7                    ;ADD7: 96 E7 
        CMPA    #$08                     ;ADD9: 81 08 
        BNE     ZADE9                    ;ADDB: 26 0C 
        LDA     M80F0                    ;ADDD: 96 F0 
        STA     -$01,U                   ;ADDF: A7 5F 
        LEAU    $03,U                    ;ADE1: 33 43 
        STU     M80EE                    ;ADE3: DF EE 
        CLR     M80F0                    ;ADE5: 0F F0 
        BRA     ZAE15                    ;ADE7: 20 2C 
;------------------------------------------------------------------------
ZADE9:	CMPA    #$0A                     ;ADE9: 81 0A 
        BNE     ZADF9                    ;ADEB: 26 0C 
        LDA     M80F0                    ;ADED: 96 F0 
        STA     -$01,U                   ;ADEF: A7 5F 
        LEAU    $03,U                    ;ADF1: 33 43 
        STU     M80EE                    ;ADF3: DF EE 
        CLR     M80F0                    ;ADF5: 0F F0 
        BRA     ZAE15                    ;ADF7: 20 1C 
;------------------------------------------------------------------------
ZADF9:	CMPA    #$06                     ;ADF9: 81 06 
        BNE     ZAE15                    ;ADFB: 26 18 
        LDA     ,U                       ;ADFD: A6 C4 
        CMPA    #$83                     ;ADFF: 81 83 
        BCS     ZAE15                    ;AE01: 25 12 
        CLR     -$01,U                   ;AE03: 6F 5F 
        LEAU    $03,U                    ;AE05: 33 43 
        STU     M80EE                    ;AE07: DF EE 
        PSHS    B                        ;AE09: 34 04 
        JSR     ZAB60                    ;AE0B: BD AB 60 
        LDA     #$19                     ;AE0E: 86 19 
        JSR     pedal_handler_if_8028_not_zero ;AE10: BD A4 04 
        PULS    B                        ;AE13: 35 04 
ZAE15:	PULS    PC,CC                    ;AE15: 35 81 
;------------------------------------------------------------------------
ZAE17:	LDU     #MUX_base                ;AE17: CE E4 18 
        LDD     #M0000                   ;AE1A: CC 00 00 
ZAE1D:	JSR     ROM_set_VCF_A_B          ;AE1D: BD F5 E7 
        CMPU    #ME420                   ;AE20: 11 83 E4 20 
        BNE     ZAE1D                    ;AE24: 26 F7 
        LDU     #voice1_data             ;AE26: CE B0 52 
        LDD     #code_8ad7_via_D         ;AE29: CC 8A D7 
        LDX     #code_8bbe_via_DX        ;AE2C: 8E 8B BE 
ZAE2F:	STD     $1C,U                    ;AE2F: ED C8 1C 
        STX     $2B,U                    ;AE32: AF C8 2B 
        CLR     $1A,U                    ;AE35: 6F C8 1A 
        LEAU    $4D,U                    ;AE38: 33 C8 4D 
        CMPU    #voiceX_data_end         ;AE3B: 11 83 B2 BA 
        BCS     ZAE2F                    ;AE3F: 25 EE 
        RTS                              ;AE41: 39 
;------------------------------------------------------------------------

; stack frames for all 4 tasks
task0_BOS:
        RMB     %0000000001110111        ;AE42: 

task0_TOS:
        RMB     %0000000001111000        ;AEB9: 

task1_TOS:
        RMB     %0000000010100000        ;AF31: 

task2_TOS:
        RMB     %0000000001111111        ;AFD1: 

voice1_data_offs2:
        RMB     %0000000000000001        ;B050: 

task3_TOS:
        FCB     $FF                      ;B051: FF 

; 8 voice data sets per 77 bytes
voice1_data:
        FCB     $00,$00                  ;B052: 00 00 
MB054:	FCB     $00,$00,$80,$68,$00,$00  ;B054: 00 00 80 68 00 00 
        FCB     $00,$00,$B4,$FE,$B3,$1E  ;B05A: 00 00 B4 FE B3 1E 
        FCB     $EC,$7F,$02,$00,$00,$10  ;B060: EC 7F 02 00 00 10 
        FCB     $04,$01,$00,$00,$00,$00  ;B066: 04 01 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B06C: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B072: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B078: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B07E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00      ;B084: 00 00 00 00 00 

irq_hdlr_osc00_01:
        FCB     $00,$00,$00,$00,$00,$00  ;B089: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00      ;B08F: 00 00 00 00 00 

irq_hdlr_osc02_03:
        FCB     $00,$00,$00,$00,$00,$00  ;B094: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00      ;B09A: 00 00 00 00 00 

voice2_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B09F: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B0A5: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$83,$02,$00  ;B0AB: B3 1E EC 83 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B0B1: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B0B7: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B0BD: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B0C3: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B0C9: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B0CF: 00 00 00 00 00 00 
        FCB     $00                      ;B0D5: 00 

irq_hdlr_osc04_05:
        FCB     $00,$00,$00,$00,$00,$00  ;B0D6: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$10      ;B0DC: 00 00 00 00 10 

irq_hdlr_osc06_07:
        FCB     $00,$00,$00,$00,$00,$00  ;B0E1: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$10      ;B0E7: 00 00 00 00 10 

voice3_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B0EC: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B0F2: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$87,$02,$00  ;B0F8: B3 1E EC 87 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B0FE: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B104: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B10A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B110: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B116: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B11C: 00 00 00 00 00 00 
        FCB     $00                      ;B122: 00 

irq_hdlr_osc08_09:
        FCB     $00,$00,$00,$00,$00,$00  ;B123: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$20      ;B129: 00 00 00 00 20 

irq_hdlr_osc10_11:
        FCB     $00,$00,$00,$00,$00,$00  ;B12E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$20      ;B134: 00 00 00 00 20 

voice4_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B139: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B13F: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$8B,$02,$00  ;B145: B3 1E EC 8B 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B14B: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B151: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B157: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B15D: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B163: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B169: 00 00 00 00 00 00 
        FCB     $00                      ;B16F: 00 

irq_hdlr_osc12_13:
        FCB     $00,$00,$00,$00,$00,$00  ;B170: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$30      ;B176: 00 00 00 00 30 

irq_hdlr_osc14_15:
        FCB     $00,$00,$00,$00,$00,$00  ;B17B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$30      ;B181: 00 00 00 00 30 

voice5_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B186: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B18C: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$8F,$02,$00  ;B192: B3 1E EC 8F 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B198: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B19E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1A4: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1AA: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1B0: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1B6: 00 00 00 00 00 00 
        FCB     $00                      ;B1BC: 00 

irq_hdlr_osc16_17:
        FCB     $00,$00,$00,$00,$00,$00  ;B1BD: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$40      ;B1C3: 00 00 00 00 40 

irq_hdlr_osc18_19:
        FCB     $00,$00,$00,$00,$00,$00  ;B1C8: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$40      ;B1CE: 00 00 00 00 40 

voice6_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B1D3: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B1D9: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$93,$02,$00  ;B1DF: B3 1E EC 93 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B1E5: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1EB: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1F1: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1F7: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B1FD: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B203: 00 00 00 00 00 00 
        FCB     $00                      ;B209: 00 

irq_hdlr_osc20_21:
        FCB     $00,$00,$00,$00,$00,$00  ;B20A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$50      ;B210: 00 00 00 00 50 

irq_hdlr_osc22_23:
        FCB     $00,$00,$00,$00,$00,$00  ;B215: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$50      ;B21B: 00 00 00 00 50 

voice7_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B220: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B226: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$97,$02,$00  ;B22C: B3 1E EC 97 02 00 
        FCB     $00,$10,$04,$01,$00,$00  ;B232: 00 10 04 01 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B238: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B23E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B244: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B24A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B250: 00 00 00 00 00 00 
        FCB     $00                      ;B256: 00 

irq_hdlr_osc24_25:
        FCB     $00,$00,$00,$00,$00,$00  ;B257: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$60      ;B25D: 00 00 00 00 60 

irq_hdlr_osc26_27:
        FCB     $00,$00,$00,$00,$00,$00  ;B262: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$E0      ;B268: 00 00 00 00 E0 

voice8_data:
        FCB     $00,$00,$00,$00,$80,$68  ;B26D: 00 00 00 00 80 68 
        FCB     $00,$00,$00,$00,$B4,$FE  ;B273: 00 00 00 00 B4 FE 
        FCB     $B3,$1E,$EC,$9B,$02,$00  ;B279: B3 1E EC 9B 02 00 
        FCB     $00,$10,$04,$01          ;B27F: 00 10 04 01 
MB283:	FCB     $00,$00,$00,$00,$00,$00  ;B283: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B289: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B28F: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B295: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B29B: 00 00 00 00 00 00 
        FCB     $00,$00,$00              ;B2A1: 00 00 00 

irq_hdlr_osc28_29:
        FCB     $00,$00,$00,$00,$00,$00  ;B2A4: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$F0      ;B2AA: 00 00 00 00 F0 

irq_hdlr_osc30_31:
        FCB     $00,$00,$00,$00,$00,$00  ;B2AF: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$F0      ;B2B5: 00 00 00 00 F0 

voiceX_data_end:
        FCB     $00,$00,$00,$00          ;B2BA: 00 00 00 00 

; holds four task pointers
context_storage:
        FDB     M0000,$FFFF,$FFFF,$FFFF  ;B2BE: 00 00 FF FF FF FF FF FF 

context_storage_end:
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2C6: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2CC: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2D2: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2D8: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2DE: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2E4: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2EA: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2F0: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B2F6: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$00,$00,$00  ;B2FC: FF FF FF 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B302: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B308: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B30E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B314: 00 00 00 00 00 00 
        FCB     $00,$00,$00              ;B31A: 00 00 00 

data_b31d_via_X:
        FCB     $32                      ;B31D: 32 

; these have the form pointer cur / pointer next / pointer cur / pointer next / 5 bytes / be1e / 9 bytes
vec0_via_8eaf:
        FCB     $B3,$DE,$B3,$E0,$B3,$DE  ;B31E: B3 DE B3 E0 B3 DE 
        FCB     $B3,$E0,$00,$02,$00,$00  ;B324: B3 E0 00 02 00 00 
        FCB     $00,$BE,$1E,$00,$00,$00  ;B32A: 00 BE 1E 00 00 00 
        FCB     $00,$F0,$00,$00,$00,$00  ;B330: 00 F0 00 00 00 00 

vec1_via_8eaf:
        FCB     $B3,$FE,$B4,$1E,$B3,$FE  ;B336: B3 FE B4 1E B3 FE 
        FCB     $B4,$1E,$00,$00,$00,$00  ;B33C: B4 1E 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B342: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B348: 01 F0 00 00 00 00 

vec2_via_8eaf:
        FCB     $B4,$1E,$B4,$3E,$B4,$1E  ;B34E: B4 1E B4 3E B4 1E 
        FCB     $B4,$3E,$00,$00,$00,$00  ;B354: B4 3E 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B35A: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B360: 01 F0 00 00 00 00 

vec3_via_8eaf:
        FCB     $B4,$3E,$B4,$5E,$B4,$3E  ;B366: B4 3E B4 5E B4 3E 
        FCB     $B4,$5E,$00,$00,$00,$00  ;B36C: B4 5E 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B372: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B378: 01 F0 00 00 00 00 

vec4_via_8eaf:
        FCB     $B4,$5E,$B4,$7E,$B4,$5E  ;B37E: B4 5E B4 7E B4 5E 
        FCB     $B4,$7E,$00,$00,$00,$00  ;B384: B4 7E 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B38A: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B390: 01 F0 00 00 00 00 

vec5_via_8eaf:
        FCB     $B4,$7E,$B4,$9E,$B4,$7E  ;B396: B4 7E B4 9E B4 7E 
        FCB     $B4,$9E,$00,$00,$00,$00  ;B39C: B4 9E 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B3A2: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B3A8: 01 F0 00 00 00 00 

vec6_via_8eaf:
        FCB     $B4,$9E,$B4,$BE,$B4,$9E  ;B3AE: B4 9E B4 BE B4 9E 
        FCB     $B4,$BE,$00,$00,$00,$00  ;B3B4: B4 BE 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B3BA: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B3C0: 01 F0 00 00 00 00 

vec7_via_8eaf:
        FCB     $B4,$BE,$B4,$FE,$B4,$BE  ;B3C6: B4 BE B4 FE B4 BE 
        FCB     $B4,$FE,$00,$00,$00,$00  ;B3CC: B4 FE 00 00 00 00 
        FCB     $00                      ;B3D2: 00 

data0_via_b31e:
        FCB     $BE,$1E,$00,$01,$00,$01  ;B3D3: BE 1E 00 01 00 01 
        FCB     $F0,$00,$00,$00,$00,$00  ;B3D9: F0 00 00 00 00 00 
        FCB     $00,$01,$00,$FF,$FF,$FF  ;B3DF: 00 01 00 FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B3E5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B3EB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B3F1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B3F7: FF FF FF FF FF FF 
        FCB     $FF                      ;B3FD: FF 

data1_via_b336:
        FCB     $40,$37,$00,$00,$00,$00  ;B3FE: 40 37 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B404: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B40A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B410: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B416: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B41C: 00 00 

data2_via_b34e:
        FCB     $80,$37,$00,$00,$00,$00  ;B41E: 80 37 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B424: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B42A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B430: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B436: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B43C: 00 00 

data3_via_b366:
        FCB     $C0,$37,$FF,$FF,$FF,$FF  ;B43E: C0 37 FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B444: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B44A: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B450: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B456: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;B45C: FF FF 

data4_via_b37e:
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B45E: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B464: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B46A: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B470: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B476: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;B47C: FF FF 

data5_via_b396:
        FCB     $FF,$FF,$00,$00,$00,$00  ;B47E: FF FF 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B484: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B48A: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B490: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B496: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B49C: 00 00 

data6_via_b3ae:
        FCB     $00,$00,$00,$00,$00,$00  ;B49E: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B4A4: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B4AA: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B4B0: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B4B6: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B4BC: 00 00 

data7_via_b3c6:
        FCB     $00,$00,$FF,$FF,$FF,$FF  ;B4BE: 00 00 FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4C4: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4CA: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4D0: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4D6: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4DC: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4E2: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4E8: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4EE: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B4F4: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF          ;B4FA: FF FF FF FF 

tab_b4fe_step36:
        FCB     $00,$0E,$00,$01,$FC,$00  ;B4FE: 00 0E 00 01 FC 00 
        FCB     $00,$04,$04,$00,$00,$00  ;B504: 00 04 04 00 00 00 
        FCB     $01,$0C,$0C,$04,$0C,$00  ;B50A: 01 0C 0C 04 0C 00 
        FCB     $00,$00,$00,$00,$02,$1E  ;B510: 00 00 00 00 02 1E 
        FCB     $14,$18,$0A,$00,$00,$00  ;B516: 14 18 0A 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B51C: 00 00 00 00 00 00 
        FCB     $00,$0C,$00,$01,$FC,$00  ;B522: 00 0C 00 01 FC 00 
        FCB     $00,$00,$04,$00,$00,$00  ;B528: 00 00 04 00 00 00 
        FCB     $01,$1F,$0A,$0C,$0C,$00  ;B52E: 01 1F 0A 0C 0C 00 
        FCB     $00,$00,$00,$00,$01,$1F  ;B534: 00 00 00 00 01 1F 
        FCB     $14,$18,$19,$00,$00,$00  ;B53A: 14 18 19 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B540: 00 00 00 00 00 00 
        FCB     $00,$08,$02,$01,$3C,$00  ;B546: 00 08 02 01 3C 00 
        FCB     $00,$00,$03,$00,$00,$00  ;B54C: 00 00 03 00 00 00 
        FCB     $0A,$1F,$18,$18,$18,$00  ;B552: 0A 1F 18 18 18 00 
        FCB     $00,$00,$00,$00,$02,$1E  ;B558: 00 00 00 00 02 1E 
        FCB     $14,$18,$19,$00,$00,$00  ;B55E: 14 18 19 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B564: 00 00 00 00 00 00 
        FCB     $00,$08,$02,$01,$3C,$00  ;B56A: 00 08 02 01 3C 00 
        FCB     $00,$00,$03,$00,$00,$00  ;B570: 00 00 03 00 00 00 
        FCB     $0A,$1F,$18,$18,$18,$00  ;B576: 0A 1F 18 18 18 00 
        FCB     $00,$00,$00,$00,$02,$1E  ;B57C: 00 00 00 00 02 1E 
        FCB     $14,$18,$19,$00,$00,$00  ;B582: 14 18 19 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B588: 00 00 00 00 00 00 

data_b58e_via_X:
        FCB     $32                      ;B58E: 32 

; these have the form pointer cur / pointer next / pointer cur / pointer next / 5 bytes / be1e / 9 bytes
vec0_via_8ebf:
        FCB     $B6,$4F,$B6,$51,$B6,$4F  ;B58F: B6 4F B6 51 B6 4F 
        FCB     $B6,$51,$00,$04,$00,$00  ;B595: B6 51 00 04 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B59B: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B5A1: 01 F0 00 00 00 00 

vec1_via_8ebf:
        FCB     $B6,$6F,$B6,$8F,$B6,$6F  ;B5A7: B6 6F B6 8F B6 6F 
        FCB     $B6,$8F,$00,$00,$00,$00  ;B5AD: B6 8F 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B5B3: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B5B9: 01 F0 00 00 00 00 

vec2_via_8ebf:
        FCB     $B6,$8F,$B6,$AF,$B6,$8F  ;B5BF: B6 8F B6 AF B6 8F 
        FCB     $B6,$AF,$00,$00,$00,$00  ;B5C5: B6 AF 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B5CB: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B5D1: 01 F0 00 00 00 00 

vec3_via_8ebf:
        FCB     $B6,$AF,$B6,$CF,$B6,$AF  ;B5D7: B6 AF B6 CF B6 AF 
        FCB     $B6,$CF,$00,$00,$00,$00  ;B5DD: B6 CF 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B5E3: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B5E9: 01 F0 00 00 00 00 

vec4_via_8ebf:
        FCB     $B6,$CF,$B6,$EF,$B6,$CF  ;B5EF: B6 CF B6 EF B6 CF 
        FCB     $B6,$EF,$00,$00,$00,$00  ;B5F5: B6 EF 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B5FB: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B601: 01 F0 00 00 00 00 

vec5_via_8ebf:
        FCB     $B6,$EF,$B7              ;B607: B6 EF B7 

data_b60a_via_D:
        FCB     $0F,$B6,$EF,$B7,$0F,$00  ;B60A: 0F B6 EF B7 0F 00 
        FCB     $00,$00,$00,$00,$BE,$1E  ;B610: 00 00 00 00 BE 1E 
        FCB     $00,$01,$00,$01,$F0,$00  ;B616: 00 01 00 01 F0 00 
        FCB     $00,$00,$00              ;B61C: 00 00 00 

vec6_via_8ebf:
        FCB     $B7,$0F,$B7,$2F,$B7,$0F  ;B61F: B7 0F B7 2F B7 0F 
        FCB     $B7,$2F,$00,$00,$00,$00  ;B625: B7 2F 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B62B: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B631: 01 F0 00 00 00 00 

vec7_via_8ebf:
        FCB     $B7,$2F,$B7,$4F,$B7,$2F  ;B637: B7 2F B7 4F B7 2F 
        FCB     $B7,$4F,$00,$00,$00,$00  ;B63D: B7 4F 00 00 00 00 
        FCB     $00,$BE,$1E,$00,$01,$00  ;B643: 00 BE 1E 00 01 00 
        FCB     $01,$F0,$00,$00,$00,$00  ;B649: 01 F0 00 00 00 00 

data0_via_b85f:
        FCB     $00,$00                  ;B64F: 00 00 

data0_next_init:
        FCB     $01,$01,$FF,$FF,$FF,$FF  ;B651: 01 01 FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B657: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B65D: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B663: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B669: FF FF FF FF FF FF 

data1_via_b5a7:
        FCB     $40,$3F,$FF,$FF,$FF,$FF  ;B66F: 40 3F FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B675: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$00  ;B67B: FF FF FF FF FF 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B681: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B687: 00 00 00 00 00 00 
        FCB     $00                      ;B68D: 00 

b68e_via_D:
        FCB     $00                      ;B68E: 00 

data2_via_b5bf:
        FCB     $80,$3F,$00,$00,$00,$00  ;B68F: 80 3F 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B695: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B69B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B6A1: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B6A7: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B6AD: 00 00 

data3_via_b5d7:
        FCB     $C0,$3F,$00,$00,$00,$00  ;B6AF: C0 3F 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B6B5: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$FF  ;B6BB: 00 00 00 00 00 FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6C1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6C7: FF FF FF FF FF FF 
        FCB     $FF                      ;B6CD: FF 

b6ce_via_D:
        FCB     $FF                      ;B6CE: FF 

data4_via_b5ef:
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6CF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6D5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6DB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6E1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6E7: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;B6ED: FF FF 

data5_via_b607:
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6EF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B6F5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$00,$00  ;B6FB: FF FF FF FF 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B701: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B707: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B70D: 00 00 

data6_via_b61f:
        FCB     $00,$00,$00,$00,$00,$00  ;B70F: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B715: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B71B: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B721: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B727: 00 00 00 00 00 00 
        FCB     $00,$00                  ;B72D: 00 00 

data7_via_b637:
        FCB     $00,$00,$00,$00,$00,$00  ;B72F: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B735: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$FF  ;B73B: 00 00 00 00 00 FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B741: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B747: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;B74D: FF FF 

dataX_b6XX_end:
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B74F: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B755: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B75B: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B761: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B767: FF FF FF FF FF FF 
        FCB     $FF,$FF                  ;B76D: FF FF 

tab_b76f_step36:
        FCB     $00,$0C,$00,$01,$FC,$00  ;B76F: 00 0C 00 01 FC 00 
        FCB     $00,$00,$04,$00,$00,$00  ;B775: 00 00 04 00 00 00 
        FCB     $18,$1F,$18,$18,$18,$00  ;B77B: 18 1F 18 18 18 00 
        FCB     $00,$00,$00,$00,$05,$1E  ;B781: 00 00 00 00 05 1E 
        FCB     $14,$18,$18,$0A,$00,$00  ;B787: 14 18 18 0A 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B78D: 00 00 00 00 00 00 
        FCB     $00,$0C,$00,$01,$FC,$00  ;B793: 00 0C 00 01 FC 00 
        FCB     $00,$00,$03,$00,$00,$00  ;B799: 00 00 03 00 00 00 
        FCB     $01,$1F,$0A              ;B79F: 01 1F 0A 

data_via_ab2a:
        FCB     $0A,$0A,$00,$00,$00,$00  ;B7A2: 0A 0A 00 00 00 00 
        FCB     $00,$01,$1F,$0A,$14,$0A  ;B7A8: 00 01 1F 0A 14 0A 
        FCB     $00,$00,$00,$00,$00,$00  ;B7AE: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$08,$02  ;B7B4: 00 00 00 00 08 02 
        FCB     $01,$3C,$00,$00,$00,$03  ;B7BA: 01 3C 00 00 00 03 
        FCB     $00,$00,$00,$0A,$1F,$18  ;B7C0: 00 00 00 0A 1F 18 
        FCB     $18,$18,$00,$00,$00,$00  ;B7C6: 18 18 00 00 00 00 
        FCB     $00,$02,$1E,$14,$18,$19  ;B7CC: 00 02 1E 14 18 19 
        FCB     $00,$00,$00,$00,$00,$00  ;B7D2: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$08,$02  ;B7D8: 00 00 00 00 08 02 
        FCB     $01,$3C,$00,$00,$00,$03  ;B7DE: 01 3C 00 00 00 03 
        FCB     $00,$00,$00,$0A,$1F,$18  ;B7E4: 00 00 00 0A 1F 18 
        FCB     $18,$18,$00,$00,$00,$00  ;B7EA: 18 18 00 00 00 00 
        FCB     $00,$02,$1E,$14,$18,$19  ;B7F0: 00 02 1E 14 18 19 
        FCB     $00,$00,$00,$00,$00,$00  ;B7F6: 00 00 00 00 00 00 
        FCB     $00,$00,$00,$00          ;B7FC: 00 00 00 00 
MB800:	FCB     $01,$39,$39,$39          ;B800: 01 39 39 39 

vec_b804:
        FDB     ptr_b80a                 ;B804: B8 0A 

vec_sysmsg:
        FDB     data_sysmsg              ;B806: B8 35 

vec_b808:
        FDB     ptr_b80a                 ;B808: B8 0A 

ptr_b80a:
        FCB     $00,$C9,$40,$00,$00,$40  ;B80A: 00 C9 40 00 00 40 
        FCB     $00,$01,$00,$00,$03,$00  ;B810: 00 01 00 00 03 00 
        FCB     $18,$49,$40,$00,$CB,$40  ;B816: 18 49 40 00 CB 40 
        FCB     $18,$4B,$40,$00,$C7,$40  ;B81C: 18 4B 40 00 C7 40 
        FCB     $18,$47,$40,$00,$BB,$40  ;B822: 18 47 40 00 BB 40 
        FCB     $18,$3B,$40,$00,$C2,$40  ;B828: 18 3B 40 00 C2 40 
        FCB     $60,$42,$40,$00,$80,$80  ;B82E: 60 42 40 00 80 80 
        FCB     $80                      ;B834: 80 

data_sysmsg:
        FCB     $00,'M','i','r','a','g'  ;B835: 00 4D 69 72 61 67 
        FCB     'e',' ','O','p','e','r'  ;B83B: 65 20 4F 70 65 72 
        FCB     'a','t','i','n','g',' '  ;B841: 61 74 69 6E 67 20 
        FCB     'S','y','s','t','e','m'  ;B847: 53 79 73 74 65 6D 
        FCB     ' ','c','o','p','y','r'  ;B84D: 20 63 6F 70 79 72 
        FCB     'i','g','h','t',' ','1'  ;B853: 69 67 68 74 20 31 
        FCB     '9','8','4',' ','E','n'  ;B859: 39 38 34 20 45 6E 
        FCB     's','o','n','i','q',' '  ;B85F: 73 6F 6E 69 71 20 
        FCB     'C','o','r','p','.',' '  ;B865: 43 6F 72 70 2E 20 
        FCB     ' ',' ','b','y',' ','A'  ;B86B: 20 20 62 79 20 41 
        FCB     'l','e','x',' ','L','i'  ;B871: 6C 65 78 20 4C 69 
        FCB     'm','b','e','r','i','s'  ;B877: 6D 62 65 72 69 73 
        FCB     ',',' ','J','.',' ','W'  ;B87D: 2C 20 4A 2E 20 57 
        FCB     'i','l','l','i','a','m'  ;B883: 69 6C 6C 69 61 6D 
        FCB     ' ','M','a','u','c','h'  ;B889: 20 4D 61 75 63 68 
        FCB     'l','y',',',' ','J','o'  ;B88F: 6C 79 2C 20 4A 6F 
        FCB     'h','n',' ','O','.',' '  ;B895: 68 6E 20 4F 2E 20 
        FCB     'S','e','n','i','o','r'  ;B89B: 53 65 6E 69 6F 72 
        FCB     ' ','a','n','d',' ','A'  ;B8A1: 20 61 6E 64 20 41 
        FCB     'l','a','n',' ','S','m'  ;B8A7: 6C 61 6E 20 53 6D 
        FCB     'i','t','h',' ',' ',' '  ;B8AD: 69 74 68 20 20 20 
        FCB     ' ',$00,$00,$00,$00,$00  ;B8B3: 20 00 00 00 00 00 
        FCB     $00,$00,$00,$00,$00,$00  ;B8B9: 00 00 00 00 00 00 
        FCB     $00,$FF,$FF,$FF,$FF,$FF  ;B8BF: 00 FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8C5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8CB: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8D1: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8D7: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8DD: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8E3: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8E9: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8EF: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$FF,$FF  ;B8F5: FF FF FF FF FF FF 
        FCB     $FF,$FF,$FF,$FF,$00      ;B8FB: FF FF FF FF 00 
;------------------------------------------------------------------------

init_task_table:
        LDD     #flag_8038_0_marks_empty_8059_task ;B900: CC 80 38 
        TFR     A,DP                     ;B903: 1F 8B 
        LDY     #context_storage         ;B905: 10 8E B2 BE 
        LDX     #vectors_b987            ;B909: 8E B9 87 

init_task_table_loop:
        LDS     ,X++                     ;B90C: 10 EE 81 
        LDD     ,X++                     ;B90F: EC 81 
        PSHS    D                        ;B911: 34 06 
        STS     ,Y++                     ;B913: 10 EF A1 
        CMPX    #OSRAM_unused            ;B916: 8C B9 97 
        BCS     init_task_table_loop     ;B919: 25 F1 
        ANDCC   #$AF                     ;B91B: 1C AF 
        JMP     context_switch_init_ptr  ;B91D: 7E 88 68 
;------------------------------------------------------------------------

osentry:
        LDS     #voice1_data             ;B920: 10 CE B0 52 
        LDD     #flag_8038_0_marks_empty_8059_task ;B924: CC 80 38 
        TFR     A,DP                     ;B927: 1F 8B 
        JSR     task_handler_875e        ;B929: BD 87 5E 
        JSR     tune_filters             ;B92C: BD B9 6E 
        JSR     kbd_init_parser          ;B92F: BD 89 6B 
        JMP     init_task_table          ;B932: 7E B9 00 
;------------------------------------------------------------------------

tune_pitchbend:
        LDA     #$18                     ;B935: 86 18 
        STA     VIA_dr_b                 ;B937: B7 E2 00 
        LDA     DOC_oer                  ;B93A: B6 EC E1 
        LDA     DOC_adc                  ;B93D: B6 EC E2 
        MUL                              ;B940: 3D 
        MUL                              ;B941: 3D 
        MUL                              ;B942: 3D 
        LDB     DOC_adc                  ;B943: F6 EC E2 
        STB     adc_buf3                 ;B946: F7 90 0E 
        MUL                              ;B949: 3D 
        MUL                              ;B94A: 3D 
        MUL                              ;B94B: 3D 
        LDB     DOC_adc                  ;B94C: F6 EC E2 
        STB     adc_buf2                 ;B94F: F7 90 0D 
        MUL                              ;B952: 3D 
        MUL                              ;B953: 3D 
        MUL                              ;B954: 3D 
        LDB     DOC_adc                  ;B955: F6 EC E2 
        STB     adc_buf1                 ;B958: F7 90 0C 
        CLRA                             ;B95B: 4F 
        ADDB    adc_buf2                 ;B95C: FB 90 0D 
        ADCA    #$00                     ;B95F: 89 00 
        ADDB    adc_buf3                 ;B961: FB 90 0E 
        ADCA    #$00                     ;B964: 89 00 
        ASRA                             ;B966: 47 
        RORB                             ;B967: 56 
        ASRA                             ;B968: 47 
        RORB                             ;B969: 56 
        STB     adc_result               ;B96A: F7 90 0A 
        RTS                              ;B96D: 39 
;------------------------------------------------------------------------

tune_filters:
        LDU     #voice1_data_offs2       ;B96E: CE B0 50 
        LDX     #MUX_base                ;B971: 8E E4 18 

tune_filters_loop:
        LDB     #$10                     ;B974: C6 10 
        JSR     ROM_tune_filters         ;B976: BD F5 71 
        LEAU    $4D,U                    ;B979: 33 C8 4D 
        LEAX    $01,X                    ;B97C: 30 01 
        CMPX    #VCF_base                ;B97E: 8C E4 1F 
        BLS     tune_filters_loop        ;B981: 23 F1 
        JSR     tune_pitchbend           ;B983: BD B9 35 
        RTS                              ;B986: 39 
;------------------------------------------------------------------------

; 4 sets of S/D vectors, D get pushed to stack, S gets stored to b2be/c0/c2/c4
vectors_b987:
        FDB     task0_TOS,task0_code_D   ;B987: AE B9 90 0F 
        FDB     task1_TOS,task1_code_D   ;B98B: AF 31 90 1F 
        FDB     task2_TOS,task2_code_D   ;B98F: AF D1 90 E2 
        FDB     task3_TOS,task3_code_D   ;B993: B0 51 AC 4F 

        END
