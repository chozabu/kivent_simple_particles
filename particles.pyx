__author__ = 'chozabu'

gameref = None

enable_particles = 1

from random import random

particles = []

cdef class particle:
	def __init__(self, ent, vel,lifespan, drag, gravity):
		self.ent=ent
		self.vx=vel[0]
		self.vy=vel[1]
		self.lifespan=lifespan
		self.maxlifespan=lifespan
		self.drag = drag
		self.gx=gravity[0]
		self.gy=gravity[1]
	def entity_id(self):
		return self.ent
	def updateme(self, list ents, float dt):
		cdef float ls = self.lifespan
		cdef float mls = self.maxlifespan
		ent = ents[self.ent]
		self.vx = self.vx*self.drag+self.gx
		self.vy = self.vy*self.drag+self.gy
		ent.position.x+=self.vx
		ent.position.y+=self.vy
		ent.color.a=ls/mls
		ent.scale.s=ls/(mls*.5)
		self.lifespan-=dt
		return self.lifespan

def spawn_particles_at(pos, vel=(0,0), color=(1,1,1,1), float lifespan=1., float drag=.95, gravity=(0,0), float radius=64):
	if enable_particles==0:return
	pid = create_visual(pos, color=color, radius=radius*.5)
	#ent = gameref.gameworld.entities[pid]
	newp = particle(pid,vel,lifespan=lifespan, drag=drag, gravity=gravity)
	particles.append(newp)

def update(float dt):
	global particles
	ents = gameref.gameworld.entities
	remlist=[]
	for p in particles:
		ls = p.updateme(ents, dt)
		#print ls
		if ls<0:
			remlist.append(p)
			gameref.gameworld.remove_entity(p.entity_id())
	for r in remlist:
		particles.remove(r)



cdef create_visual(pos, color,float radius=64):

	create_component_dict = {
		'renderer': {'texture': 'particle',
		'size': (radius,radius)},
		'position': pos, 'rotate': 0, 'color': color,
		#'lerp_system': {},
		'scale':1.}
	component_order = ['position', 'rotate', 'color',
		'renderer','scale']
	eid = gameref.gameworld.init_entity(create_component_dict,
		component_order)
	return eid