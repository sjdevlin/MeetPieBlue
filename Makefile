# Makefile for Raspberry Pi
BTSTACK_ROOT ?= ./

CORE += \
	btstack_chipset_bcm.c \
	btstack_chipset_bcm_download_firmware.c \
	btstack_control_raspi.c \
	btstack_link_key_db_tlv.c \
	btstack_run_loop_posix.c \
	btstack_tlv_posix.c \
	btstack_uart_block_posix.c \
	btstack_slip.c \
	hci_transport_h4.c \
	hci_transport_h5.c \
	le_device_db_tlv.c \
	main.c \
	wav_util.c 					\
	btstack_stdin_posix.c \
	raspi_get_model.c \
	rijndael.c

CORE += \
	btstack_memory.c            \
	btstack_linked_list.c	    \
	btstack_memory_pool.c       \
	btstack_run_loop.c		    \
	btstack_util.c 	            \
	ad_parser.c                 \
	hci.c			            \
	hci_cmd.c		            \
	hci_dump.c		            \
	l2cap.c			            \
	l2cap_signaling.c	        \
	btstack_audio.c             \
	btstack_tlv.c               \
	btstack_crypto.c            \
	uECC.c                      \
	sm.c                        \
	att_dispatch.c       	    \
	att_db.c 				 	    \
	att_server.c

# use (cross)compiler for Raspi
CC = arm-linux-gnueabihf-gcc

CFLAGS  += -g -Wall -Werror \
	-I$(BTSTACK_ROOT)/src \
	-I$(BTSTACK_ROOT)/src/ble \
	-I$(BTSTACK_ROOT)/src/classic \
	-I$(BTSTACK_ROOT)/platform/embedded \
	-I$(BTSTACK_ROOT)/platform/posix \
	-I$(BTSTACK_ROOT)/chipset/bcm \
	-I${BTSTACK_ROOT}/3rd-party/micro-ecc \
	-I${BTSTACK_ROOT}/3rd-party/tinydir \
	-I${BTSTACK_ROOT}/3rd-party/rijndael

CFLAGS += -I.


# add 'real time' lib for clock_gettime
LDFLAGS += -lrt

VPATH += ${BTSTACK_ROOT}/src
VPATH += ${BTSTACK_ROOT}/src/ble
VPATH += ${BTSTACK_ROOT}/src/ble/gatt-service
VPATH += ${BTSTACK_ROOT}/src/classic

VPATH += ${BTSTACK_ROOT}/3rd-party/rijndael
VPATH += ${BTSTACK_ROOT}/3rd-party/micro-ecc
VPATH += ${BTSTACK_ROOT}/platform/posix
VPATH += ${BTSTACK_ROOT}/platform/embedded
VPATH += ${BTSTACK_ROOT}/chipset/bcm


# .o for .c
CORE_OBJ    = $(CORE:.c=.o)

# examples

nordic_spp_le_counter: nordic_spp_le_counter.h ${CORE_OBJ} nordic_spp_service_server.o nordic_spp_le_counter.c
	${CC} $(filter-out nordic_spp_le_counter.h,$^) ${CFLAGS} ${LDFLAGS} -o $@


clean:
	rm -f  *.o *.out *.hex *.exe *.wav *.sbc 
	rm -rf *.dSYM
	rm -rf ${BTSTACK_ROOT}/bt_src/*.o
